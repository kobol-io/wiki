In this guide we will explain how to leverage on Marvell CESA units of the Armada 388 SoC to accelerate network application encryption and disk encryption. Disk encryption acceleration is very straight forward because it's happening in-kernel with kernel subsystem **dm-crypt** which already supports hardware cryptographic engine. On the other hand, encryption acceleration for userspace network applications, like Apache2, OpenSSH, etc.. requires some patching and recompiling in order to leverage on Marvell CESA units.

!!! warning "Before you go further !"
    This guide is for advanced users who understand the security implication of tweaking encryption library and cipher configuration.

## What is CESA ?

The Cryptographic Engines and Security Accelerator (CESA) reduces the CPU packet processing
overhead by performing time consuming cryptographic operations, such as:

* Advanced Encryption Standard (AES)
* Data Encryption Standard (DES)
* Triple Data Encryption Standard (3DES) encryption
* Message Digest 5 (MD5)
* Secure Hash Algorithm-1 (SHA-1)
* Secure Hash Algorithm 2 with 256 digest bit size (SHA-2) authentication

The CESA-DMA engine (also called TDMA) controls communication between the main memory and
the internal SRAM.

### CESA Functional Block Diagram

![CESA Block Diagram](/img/cesa/cesa_block_diagram.png)

The above block diagram shows a single CESA unit.

### Crypto API

Crypto API is a cryptography framework in the Linux kernel, for various parts of the kernel that deal with cryptography, such as IPsec and dm-crypt. It was introduced in kernel version 2.5.45 and has since expanded to include essentially all popular block ciphers and hash functions.

### Userspace Interfacing

Many platforms that provide hardware acceleration encryption expose this to programs through an extension of the instruction set architecture (ISA) of the various chipsets (e.g. AES instruction set for x86). With this sort of implementation any program (kernel-mode or userspace) may utilize these features directly.

However, crypto hardware engines on ARM System-On-Chip are not implemented as ISA extensions, and are only accessible through kernel-mode drivers. In order for userspace applications, such as OpenSSL, to take advantage of encryption acceleration they must interface with the kernel cryptography framework (Crypto API).

### Crypto API Interfaces

There are two interfaces that provide userspace access to the Crypto API :

* **cryptodev (/dev/crypto)**<br>cryptodev-linux is a device implemented as a standalone module that requires no dependencies other than a stock linux kernel. Its API is compatible with OpenBSD's cryptodev userspace API (/dev/crypto).

* **AF_ALG**<br>AF_ALG is a netlink-based interface that is implemented in Linux kernel mainline since version 2.6.38.

![Crypto API Interface](/img/cesa/crypto_api_interfaces.png)


## Network Application Encryption Acceleration

The following instructions have been written for **Debian Stretch** and using **cryptodev** as the Crypto API userspace interface.

You can refer to following forum [thread](https://forum.armbian.com/topic/8486-helios4-cryptographic-engines-and-security-accelerator-cesa-benchmarking/) where we explain why we choose to focus on **cryptodev**.

### Pre-Prerequisites

You will need to add *debian source* repository to your APT list in order to download **libssl** source code. Edit */etc/apt/sources.list* and uncomment the following line.

```
deb-src http://httpredir.debian.org/debian stretch main contrib non-free
```

Don't forget after to update your APT database.

```
sudo apt-get update
```

In order to compile **cryptodev** and **libssl** you will need to install the following debian packages.

```
sudo apt-get install build-essential fakeroot devscripts debhelper
```

### Install cryptodev

```
sudo apt-get install linux-headers-next-mvebu

git clone https://github.com/cryptodev-linux/cryptodev-linux.git

cd cryptodev-linux/

make

sudo make install

sudo depmod -a

sudo modprobe cryptodev
```

We can check that **cryptodev** is properly loaded with the following:

```
lsmod | grep cryptodev
cryptodev              36864  0

dmesg | grep cryptodev
[  154.966710] cryptodev: loading out-of-tree module taints kernel.
[  154.971590] cryptodev: driver 1.9 loaded.
```

To automatically load **cryptodev** at startup you can do the following. But it is strongly advice to do it after you have ensured everything works fine to avoid locking you out from Helios4.

```
echo "crytodev" >> /etc/modules
```

### Recompile OpenSSL (libssl)

OpenSSL provides the libssl and libcrypto shared libraries. **libssl** provides the client and server-side implementations for SSLv3 and TLS.

Under Debian Stretch a lot of applications, like Apache2 and OpenSSH, still depend on libssl from OpenSSL version 1.0.2, however cryptodev is only properly implemented in OpenSSL since version 1.1.1.

In order to make libssl 1.0.2 supports cryptodev, we will need to recompile Debian libssl1.0.2 after applying the patch that was originally proposed in the following [pull request](https://github.com/openssl/openssl/pull/191) in the OpenSSL project.


```
mkdir libssl; cd libssl

apt-get source libssl1.0.2
```

Apply the patch that you can find [here](/files/cesa/openssl-add-cryptodev-support.patch).

```
wget /files/cesa/openssl-add-cryptodev-support.patch

patch < openssl-add-cryptodev-support.patch openssl1.0-1.0.2l/crypto/engine/eng_cryptodev.c
```

Now let's compile libssl with **cryptodev** enabled.

```
cd openssl1.0-1.0.2l/

sed -i -e "s/CONFARGS  =/CONFARGS = -DHAVE_CRYPTODEV/" debian/rules

dch -i "Enabled cryptodev support"

DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -b -rfakeroot
```

!!! note
    Most example online will also use the -DUSE_CRYPTODEV_DIGESTS flag. However it was proven via [benchmark](/cesa/#https-benchmark) that using the CESA engine for hashing will result in performance penalty.

If all goes well you should see couple of .deb files. Look for the libssl .deb file and install it.

```
cd ..

sudo dpkg -i libssl1.0.2_1.0.2l-2+deb9u3.1_armhf.deb
```

### Apache2

In order to make Apache2 offload encryption to the hardware engine, you will need to force ciphers that use encryption algorithms supported by the Marvell CESA units:

* AES-128-CBC
* AES-192-CBC
* AES-256-CBC

Edit */etc/apache2/mods-available/ssl.conf* and modify as follow:

```
# SSL Cipher Suite
#
# SSLCipherSuite HIGH:!aNULL
SSLCipherSuite AES128-SHA
```

!!! Important
    The AES-xxx-CBC are not considered anymore as the most secured ciphers and actually won't be supported anymore in TLSv1.3. So use those ciphers at your own risk.

### OpenSSH


**Server Side:**

In order to make OpenSSH server offload encryption to the hardware engine, you will need to force ciphers that use encryption algorithms supported by the Marvell CESA units.

* AES-128-CBC
* AES-192-CBC
* AES-256-CBC

Edit */etc/ssh/sshd_config* and add the following line.

```
# Ciphers and keying
Ciphers aes128-cbc
```

**Client Side: (optional)**

To make your SSH client supports the cipher define in SSH server side, you might need to edit */etc/ssh/ssh_config* and add the following line.

```
#   Ciphers aes128-ctr,aes192-ctr,aes256-ctr,arcfour256,arcfour128,aes128-cbc,3des-cbc
Ciphers aes128-cbc
```

!!! Important
    The AES-xxx-CBC are not considered anymore as the most secured ciphers and actually won't be supported anymore in TLSv1.3. So use those ciphers at your own risk.

### HTTPS Benchmark

#### Setup

Apache2 is configured to expose a 1GB file hosted on a SSD connected to Helios4. A test PC is connected to Helios4 Ethernet directly and we use wget command to perform the file download.

Three batch of download tests, for each batch we configured Apache2 to use a specific cipher that we know is supported by the CESA engine.

* AES_128_CBC_SHA﻿
* AES_128_CBC_SHA256
* AES_256_CBC_SHA256

For each batch, we do the following 3 download tests :

1. without cryptodev module loaded (100% software encryption)
2. with cryptodev loaded and libssl (openssl) compiled with -DHAVE_CRYPTODEV -DUSE_CRYPTODEV_DIGESTS
3. with cryptodev loaded and libssl (openssl) compile only with -DHAVE_CRYPTODEV, which means hashing operation will still be done 100% by software.

#### Results

|Cipher|CPU User%| CPU Sys%|Throughput (MB/s)|
|---------------|-----|----|-----------------|
|**AES_128_CBC_SHA**|
|Software encryption|46.9|7.9|32.8|
|HW encryption with hashing|6.2|24.6|26.7|
|HW encryption without hashing|19.9|16.4|**47.8**|
|**AES_128_CBC_SHA256**|
|Software encryption|43.1|7.0|28.1|
|HW encryption with hashing|7.0|24.6|27.1|
|HW encryption without hashing|24.1|12.9|**36.6**|
|**AES_256_CBC_SHA256**|
|Software encryption|45.1|5.0|23.9|
|HW encryption with hashing|7.0|24.5|26.7|
|HW encryption without hashing|24.2|12.0|**35.8**|
|**For reference**|
|AES_128_GCM_SHA256<br>(Default Apache 2.4 TLS cipher. GCM mode is not something that can be accelerated by CESA.)|42.9|7.2|30.6|
|Clear text HTTP|1.0|29.8|112.1|

!!! note
    CPU utilization is for both cores. However each test is just a single thread process running on a single core therefore when you see CPU utilization around 50% (User% + Sys%) it means the core used for the test is fully loaded.


**CONCLUSION**

1. Hashing operation are slower on the CESA engine than the CPU itself, therefore making HW encryption with hashing is performing less than 100% software encryption.

2. HW encryption without hashing provides 30 to 50% of throughput increase while decreasing the load on the CPU by 20 to 30%.


## Accelerate Disk Encryption

Refer to the following great [tutorial](https://www.cyberciti.biz/hardware/howto-linux-hard-disk-encryption-with-luks-cryptsetup-command/) to setup disk encryption with LUKS.

## References

* [An overview of the crypto subsystem](http://events17.linuxfoundation.org/sites/events/files/slides/brezillon-crypto-framework_0.pdf)
* [Utilizing the crypto accelerators](https://events.static.linuxfound.org/sites/events/files/slides/lcj-2014-crypto-user.pdf)
* [Linux crypto](https://www.slideshare.net/nij05/slideshare-linux-crypto-60753522)
* [Crypto API definition](https://en.wikipedia.org/wiki/Crypto_API_(Linux))
* [Linux Kernel cryptography algorithm implementation process](https://szlin.me/2017/04/05/linux-kernel-%E5%AF%86%E7%A2%BC%E5%AD%B8%E6%BC%94%E7%AE%97%E6%B3%95%E5%AF%A6%E4%BD%9C%E6%B5%81%E7%A8%8B/)
* [Cryptodev benchmark](http://cryptodev-linux.org/comparison.html)
* [Accelerating crypto](https://lauri.võsandi.com/2014/07/cryptodev.html)
* [Hardware Cryptography cryptodev/openssl](https://forum.doozan.com/read.php?2,18152)
