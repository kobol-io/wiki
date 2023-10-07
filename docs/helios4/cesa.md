In this guide we will explain how to leverage on Marvell CESA units of the Armada 388 SoC to accelerate network application encryption and disk encryption. Disk encryption acceleration is very straight forward because it's happening in-kernel with kernel subsystem **dm-crypt** which already supports hardware cryptographic engine. On the other hand, encryption acceleration for userspace network applications, like Apache2, Nginx, OpenSSH, etc.. might require some patching and recompiling in order to leverage on Marvell CESA units.

!!! warning "Before you go further !"
    This guide is for advanced users who understand the security implication of tweaking encryption library and cipher configuration.

## What is CESA ?

The Cryptographic Engines and Security Accelerator (CESA) reduces the CPU packet processing overhead by performing compute intensive cryptographic operations, such as:

* Advanced Encryption Standard (AES)
* Data Encryption Standard (DES)
* Triple Data Encryption Standard (3DES) encryption
* Message Digest 5 (MD5)
* Secure Hash Algorithm-1 (SHA-1)
* Secure Hash Algorithm 2 with 256 digest bit size (SHA-2) authentication

The CESA-DMA engine (also called TDMA) controls communication between the main memory and
the internal SRAM.

### CESA Functional Block Diagram

![CESA Block Diagram](/helios4/img/cesa/cesa_block_diagram.png)

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

![Crypto API Interface](/helios4/img/cesa/crypto_api_interfaces.png)


## Network Application Encryption Acceleration


### Debian 10 Buster

The following instructions have been written for **Debian 10 Buster** and using **AF_ALG** as the Crypto API userspace interface.

We choose **AF_ALG** for Debian 10 Buster because it doesn't require any patching or recompiling. But while [benchmark](#https-benchmark) shows in some case throughput improvement with **AF_ALG**, the CPU load is not improved compared to **cryptodev** or 100% software encryption. This will require further investigation.

#### Configure OpenSSL

To make libssl use AF_ALG engine we need to configure OpenSSL master configuration file to declare the engine.

Edit */etc/ssl/openssl.cnf* and modify the bottom part of the configuration file as follow:


```
[default_conf]
ssl_conf = ssl_sect
engines = engines_sect

[ssl_sect]
system_default = system_default_sect

[system_default_sect]
MinProtocol = TLSv1.2
CipherString = DEFAULT@SECLEVEL=2

[engines_sect]
afalg = afalg_engine

[afalg_engine]
default_algorithms = ALL
```

#### Apache2

In order to make Apache2 offload encryption to the hardware engine, you will need to force ciphers that use encryption algorithms supported by the Marvell CESA units:

* AES-128-CBC
* AES-192-CBC
* AES-256-CBC

You will also need to disable usage of TLSv1.3 since AES-xxx-CBC ciphers are not supported anymore because not considered as the most secured ones.

Edit */etc/apache2/mods-available/ssl.conf* and modify as follow:

```
# SSL Cipher Suite
#
# SSLCipherSuite HIGH:!aNULL
SSLCipherSuite AES128-SHA


#   The protocols to enable.
#
#	SSLProtocol all -SSLv3
SSLProtocol all -SSLv3 -TLSv1.3
```

#### Nginx

In order to make Nginx offload encryption to the hardware engine, you will need to force ciphers that use encryption algorithms supported by the Marvell CESA units:

* AES-128-CBC
* AES-192-CBC
* AES-256-CBC

Edit */etc/nginx/nginx.conf* and modify as follow:

```
##
# SSL Settings
##

ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
ssl_prefer_server_ciphers on;
ssl_ciphers AES128-SHA;
```


#### OpenSSH

For now unfortunately you cannot accelerate OpenSSH connection because latest version of OpenSSH enforce usage of *seccomp sandbox* which forbids some syscalls required to use AF_ALG.

Refer to Debian bug [#931271](https://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg1686025.html).

### Debian 9 Stretch

The following instructions have been written for **Debian 9 Stretch** and using **cryptodev** as the Crypto API userspace interface.

You can refer to following forum [thread](https://forum.armbian.com/topic/8486-helios4-cryptographic-engines-and-security-accelerator-cesa-benchmarking/) where we explain why we choose **cryptodev** over **AF_ALG**.

#### Prerequisites

You will need to add *debian source* repository to your APT list in order to download **libssl** source code. Edit */etc/apt/sources.list* and uncomment the following lines.

```
deb-src http://httpredir.debian.org/debian stretch main contrib non-free
```

```
deb-src http://security.debian.org/ stretch/updates main contrib non-free
```

Don't forget after to update your APT database.

```
sudo apt-get update
```

In order to compile **cryptodev** and **libssl** you will need to install the following debian packages.

```
sudo apt-get install build-essential fakeroot devscripts debhelper
```

Check that **marvell_cesa** module is properly loaded with the following command:

```
lsmod | grep marvell_cesa
marvell_cesa           28672  0
```

If it's not the case, then load it manually:

```
sudo modprobe marvell_cesa
```

To automatically load **marvell_cesa** at startup you can do the following:

```
echo "marvell_cesa" >> /etc/modules
```

#### Install cryptodev

```
sudo apt-get install linux-headers-mvebu

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

#### Recompile OpenSSL (libssl)

OpenSSL provides the libssl and libcrypto shared libraries. **libssl** provides the client and server-side implementations for SSLv3 and TLS.

Under Debian Stretch a lot of applications, like Apache2 and OpenSSH, still depend on libssl from OpenSSL version 1.0.2, however cryptodev is only properly implemented in OpenSSL since version 1.1.1.

In order to make libssl 1.0.2 supports cryptodev, we will need to recompile Debian libssl1.0.2 after applying the patch that was originally proposed in the following [pull request](https://github.com/openssl/openssl/pull/191) in the OpenSSL project.


```
mkdir libssl; cd libssl

apt-get source libssl1.0.2
```

Apply the patch that you can find [here](/helios4/files/cesa/openssl-add-cryptodev-support.patch).

```
wget https://wiki.kobol.io/helios4/files/cesa/openssl-add-cryptodev-support.patch

patch < openssl-add-cryptodev-support.patch openssl1.0-1.0.2*/crypto/engine/eng_cryptodev.c
```

Now let's compile libssl with **cryptodev** enabled.

```
cd openssl1.0-1.0.2*/

sed -i -e "s/CONFARGS  =/CONFARGS = -DHAVE_CRYPTODEV/" debian/rules

dch -i "Enabled cryptodev support"

DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -b -rfakeroot
```

!!! note
    Most example online will also use the -DUSE_CRYPTODEV_DIGESTS flag. However it was proven via [benchmark](#https-benchmark) that using the CESA engine for hashing will result in performance penalty.

If all goes well you should see couple of .deb files. Look for the libssl .deb file and install it.

```
cd ..

sudo dpkg -i libssl1.0.2_1.0.2s-1~deb9u1.1_armhf.deb
```

!!! info
    A pre-build Debian libssl package (libssl1.0.2_1.0.2s-1~deb9u1.1_armhf.deb) with cryptodev enable is available [here](/helios4/files/cesa/libssl1.0.2_1.0.2s-1~deb9u1.1_armhf.deb), if you want to skip the recompile step.

#### Apache2

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
    The AES-xxx-CBC ciphers are not considered anymore as the most secured ones and actually won't be supported anymore in TLSv1.3. So use those ciphers at your own risk.

#### OpenSSH


**Server Side:**

In order to make OpenSSH server offload encryption to the hardware engine, you will need to force ciphers that use encryption algorithms supported by the Marvell CESA units.

* AES-128-CBC
* AES-192-CBC
* AES-256-CBC

Edit */etc/ssh/sshd_config* and add the following lines.

```
# Ciphers and keying
Ciphers aes128-cbc


#UsePrivilegeSeparation sandbox
UsePrivilegeSeparation yes
```

**Client Side: (optional)**

To make your SSH client supports the cipher define in SSH server side, you will need to edit */etc/ssh/ssh_config* and add the following line.

```
#   Ciphers aes128-ctr,aes192-ctr,aes256-ctr,arcfour256,arcfour128,aes128-cbc,3des-cbc
Ciphers +aes128-cbc
```

!!! Important
    The AES-xxx-CBC ciphers are not considered anymore as the most secured, so use those ciphers at your own risk.


## Troubleshooting

You can check if cryptographic operations are effectively off-loaded on the CESA units by looking at the interrupts.

We can see below that one of the **f1090000.crypto** devices, which are the CESA units, received quite a lot of interrupts. This means crypto operations where performed on the CESA units. You can monitor */proc/interrupts* to confirm the interrupt counters of the crypto devices keep increasing While performing some https or ssh tests.

```
cat /proc/interrupts

           CPU0       CPU1       
 17:   40807520   39650240     GIC-0  29 Edge      twd
 18:          0          0      MPIC   5 Level     armada_370_xp_per_cpu_tick
 19:          0          0      MPIC   3 Level     arm-pmu
 20:        176          0     GIC-0  34 Level     mv64xxx_i2c
 21:          0          0     GIC-0  35 Level     mv64xxx_i2c
 22:        715          0     GIC-0  44 Level     ttyS0
 36:    1698960          0      MPIC   8 Level     eth0
 37:          0          0     GIC-0  50 Level     ehci_hcd:usb1
 38:      64015          0     GIC-0  51 Level     f1090000.crypto
 39:          0          0     GIC-0  52 Level     f1090000.crypto
 40:          0          0     GIC-0  53 Level     f10a3800.rtc
 41:       8248          0     GIC-0  58 Level     ahci-mvebu[f10a8000.sata]
 42:          0          0     GIC-0  60 Level     ahci-mvebu[f10e0000.sata]
 43:      39902          0     GIC-0  57 Level     mmc0
 44:          0          0     GIC-0  48 Level     xhci-hcd:usb2
 45:          0          0     GIC-0  49 Level     xhci-hcd:usb4
 46:          2          0     GIC-0  54 Level     f1060800.xor
 47:          2          0     GIC-0  97 Level     f1060900.xor
 48:          0          0  f1018100.gpio  23 Level     0-0020
 49:          5          0  f1018100.gpio  20 Edge      f10d8000.sdhci cd
IPI0:          0          1  CPU wakeup interrupts
IPI1:          0          0  Timer broadcast interrupts
IPI2:     287339     328237  Rescheduling interrupts
IPI3:      27382      21677  Function call interrupts
IPI4:          0          0  CPU stop interrupts
IPI5:     401785     152498  IRQ work interrupts
IPI6:          0          0  completion interrupts
Err:          0
```


When using cryptodev engine, you can also check crypto operations are offloaded on the CESA units by looking at the cryptodev driver output messages. You will need first to increase its verbosity.

```
sudo sysctl -w ioctl.cryptodev_verbosity=3
```

Then check the cryptodev driver output with **dmesg** while performing some https or ssh tests. You should see the following.

```
dmesg | grep cryptodev

[...]
[157702.907467] cryptodev: apache2[32190] (crypto_create_session:290): got alignmask 0
[157702.907473] cryptodev: apache2[32190] (crypto_create_session:293): preallocating for 32 user pages
[157702.907735] cryptodev: apache2[32190] (crypto_create_session:290): got alignmask 0
[157702.907739] cryptodev: apache2[32190] (crypto_create_session:293): preallocating for 32 user pages
[157702.907813] cryptodev: apache2[32190] (crypto_destroy_session:348): Removed session 0xB4A5900F
[157702.907819] cryptodev: apache2[32190] (crypto_destroy_session:351): freeing space for 32 user pages
[157702.907878] cryptodev: apache2[32190] (crypto_create_session:290): got alignmask 0
[157702.907882] cryptodev: apache2[32190] (crypto_create_session:293): preallocating for 32 user page
[...]

```

To disable cryptodev verbosity.
```
sudo sysctl -w ioctl.cryptodev_verbosity=0
```

## HTTPS Benchmark

### Setup

Apache2 is configured to expose a 1GB file hosted on a SSD connected to Helios4. A test PC is connected to Helios4 Ethernet directly and we use wget command to perform the file download.

Three batch of download tests, for each batch we configured Apache2 to use a specific cipher that we know is supported by the CESA engine.

* AES_128_CBC_SHA﻿
* AES_128_CBC_SHA256
* AES_256_CBC_SHA256

For each batch, we do the following 4 download tests :

1. without cryptodev module loaded (100% software encryption).
2. with cryptodev loaded and libssl (openssl) compiled with -DHAVE_CRYPTODEV -DUSE_CRYPTODEV_DIGESTS.
3. with cryptodev loaded and libssl (openssl) compile only with -DHAVE_CRYPTODEV, which means hashing operations will still be done 100% by software.
4. with AF_ALG loaded and using libssl 1.1.1, by default hashing operations are still done 100% by software (Test done under Debian 10 Buster).

### Results

**Single thread download**

|Cipher|CPU User%| CPU Sys%|Throughput (MB/s)|
|---------------|-----|----|-----------------|
|**AES_128_CBC_SHA**|
|Software encryption|46.9|7.9|32.8|
|HW encryption with hashing (cryptodev)|6.2|24.6|26.7|
|HW encryption without hashing (cryptodev)|19.9|16.4|**47.8**|
|HW encryption without hashing (AF_ALG)|36.9|25.5|40.7|
|**AES_128_CBC_SHA256**|
|Software encryption|43.1|7.0|28.1|
|HW encryption with hashing (cryptodev)|7.0|24.6|27.1|
|HW encryption without hashing (cryptodev)|24.1|12.9|**36.6**|
|HW encryption without hashing (AF_ALG)|45.4|28.4|33.9|
|**AES_256_CBC_SHA256**|
|Software encryption|45.1|5.0|23.9|
|HW encryption with hashing (cryptodev)|7.0|24.5|26.7|
|HW encryption without hashing (cryptodev)|24.2|12.0|**35.8**|
|HW encryption without hashing (AF_ALG)|46.9|26.5|32.6|
|**For reference**|
|AES_128_GCM_SHA256<br>(Default Apache 2.4 TLS cipher. GCM mode is not something that can be accelerated by CESA.)|42.9|7.2|30.6|
|Clear text HTTP|1.0|29.8|112.1|

!!! note
    CPU utilization is for both cores. However each test is just a single thread process running on a single core therefore when you see CPU utilization around 50% (User% + Sys%) it means the core used for the test is fully loaded.

**Multi thread download**

Test with 2 simultaneous file downloads.

Cipher|CPU User%| CPU Sys%|Throughput (MB/s)|
|---------------|-----|----|-----------------|
|**AES_128_CBC_SHA**|
|Software encryption|83.5|16.5|66.5|
|HW encryption without hashing (cryptodev)|32.4|33.4|**82.3**|
|HW encryption without hashing (AF_ALG)|66.9|48.9|57.7|

**CONCLUSION**

1. Hashing operation are slower on the CESA unit than the CPU itself, therefore HW encryption acceleration with hashing is performing less than 100% software encryption.

2. Cryptodev HW encryption without hashing provides 30 to 50% of throughput increase while decreasing the load on the CPU by 20 to 30%.

3. While AF_ALG HW encryption provides throughput improvement in the single thread benchmark, it doesn't perform well in multi thread benchmark and also increases the CPU load compare to 100% software encryption.

## Disk Encryption Acceleration

Refer to the following great [tutorial](https://www.cyberciti.biz/hardware/howto-linux-hard-disk-encryption-with-luks-cryptsetup-command/) to setup disk encryption with **cryptsetup**.

In order to offload disk encryption on the CESA unit, you will need to specify to **cryptsetup** the following cipher: *aes-cbc-essiv:sha256*. Therefore the command to create your encrypted disk should looked as follow:

```
sudo cryptsetup -v -y -c aes-cbc-essiv:sha256 luksFormat /dev/sda1
```

You will need also to insure marvell_cesa module is loaded.

```
sudo modprobe marvell_cesa
```

Additionally, when running Kernel 5.8 or newer, the following patch must be applied:

```diff
diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index 0f37dfd42d85..c865d9e020e1 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -519,8 +519,7 @@ struct skcipher_alg mv_cesa_ecb_des_alg = {
                .cra_name = "ecb(des)",
                .cra_driver_name = "mv-ecb-des",
                .cra_priority = 300,
-               .cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
-                            CRYPTO_ALG_ALLOCATES_MEMORY,
+               .cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
                .cra_blocksize = DES_BLOCK_SIZE,
                .cra_ctxsize = sizeof(struct mv_cesa_des_ctx),
                .cra_alignmask = 0,
@@ -570,8 +569,7 @@ struct skcipher_alg mv_cesa_cbc_des_alg = {
                .cra_name = "cbc(des)",
                .cra_driver_name = "mv-cbc-des",
                .cra_priority = 300,
-               .cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
-                            CRYPTO_ALG_ALLOCATES_MEMORY,
+               .cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
                .cra_blocksize = DES_BLOCK_SIZE,
                .cra_ctxsize = sizeof(struct mv_cesa_des_ctx),
                .cra_alignmask = 0,
@@ -628,8 +626,7 @@ struct skcipher_alg mv_cesa_ecb_des3_ede_alg = {
                .cra_name = "ecb(des3_ede)",
                .cra_driver_name = "mv-ecb-des3-ede",
                .cra_priority = 300,
-               .cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
-                            CRYPTO_ALG_ALLOCATES_MEMORY,
+               .cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
                .cra_blocksize = DES3_EDE_BLOCK_SIZE,
                .cra_ctxsize = sizeof(struct mv_cesa_des3_ctx),
                .cra_alignmask = 0,
@@ -682,8 +679,7 @@ struct skcipher_alg mv_cesa_cbc_des3_ede_alg = {
                .cra_name = "cbc(des3_ede)",
                .cra_driver_name = "mv-cbc-des3-ede",
                .cra_priority = 300,
-               .cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
-                            CRYPTO_ALG_ALLOCATES_MEMORY,
+               .cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
                .cra_blocksize = DES3_EDE_BLOCK_SIZE,
                .cra_ctxsize = sizeof(struct mv_cesa_des3_ctx),
                .cra_alignmask = 0,
@@ -755,8 +751,7 @@ struct skcipher_alg mv_cesa_ecb_aes_alg = {
                .cra_name = "ecb(aes)",
                .cra_driver_name = "mv-ecb-aes",
                .cra_priority = 300,
-               .cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
-                            CRYPTO_ALG_ALLOCATES_MEMORY,
+               .cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
                .cra_blocksize = AES_BLOCK_SIZE,
                .cra_ctxsize = sizeof(struct mv_cesa_aes_ctx),
                .cra_alignmask = 0,
@@ -805,8 +800,7 @@ struct skcipher_alg mv_cesa_cbc_aes_alg = {
                .cra_name = "cbc(aes)",
                .cra_driver_name = "mv-cbc-aes",
                .cra_priority = 300,
-               .cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
-                            CRYPTO_ALG_ALLOCATES_MEMORY,
+               .cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
                .cra_blocksize = AES_BLOCK_SIZE,
                .cra_ctxsize = sizeof(struct mv_cesa_aes_ctx),
                .cra_alignmask = 0,

```

## References

* [An overview of the crypto subsystem](http://events17.linuxfoundation.org/sites/events/files/slides/brezillon-crypto-framework_0.pdf)
* [Utilizing the crypto accelerators](https://events.static.linuxfound.org/sites/events/files/slides/lcj-2014-crypto-user.pdf)
* [Linux crypto](https://www.slideshare.net/nij05/slideshare-linux-crypto-60753522)
* [Crypto API definition](https://en.wikipedia.org/wiki/Crypto_API_(Linux))
* [Linux Kernel cryptography algorithm implementation process](https://szlin.me/2017/04/05/linux-kernel-%E5%AF%86%E7%A2%BC%E5%AD%B8%E6%BC%94%E7%AE%97%E6%B3%95%E5%AF%A6%E4%BD%9C%E6%B5%81%E7%A8%8B/)
* [Cryptodev benchmark](http://cryptodev-linux.org/comparison.html)
* [Accelerating crypto](https://lauri.võsandi.com/2014/07/cryptodev.html)
* [Hardware Cryptography cryptodev/openssl](https://forum.doozan.com/read.php?2,18152)
