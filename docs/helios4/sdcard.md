
Helios4 SoC (Armada 388) SDIO controller supports up to UHS-I speed mode.

Following modes are supported:

* Default Speed (DS)–up to 25 MHz, 1.8V/3.3V signaling
* High Speed (HS)–up to 50 MHz, 1.8V/3.3V signaling
* SDR12–SDR up to 25 MHz, 1.8V/3.3V signaling
* SDR25–SDR up to 50 MHz, 1.8V/3.3V signaling
* SDR50–SDR up to 100 MHz, 1.8V signaling
* DDR50–DDR up to 50 MHz, 1.8V/3.3V signaling

However, it is not compatible with all cards even though the SD cards are declared as UHS-I capable. To keep it compatible with most of card, Helios4 device tree only define by default [Normal Speed mode](https://www.sdcard.org/consumers/choices/speed_class/index.html).

!!! Warning
    Enabling High Speed and UHS-I support could lead to unbootable system because of incompatible microSD card.

!!! Important
    From *Linux Kernel 4.19* onwards, High Speed and UHS-I modes for Helios4 do NOT work. It requires further work on our side.

## Device Tree Modification

To enable High Speed mode and UHS-I support, Helios4 device tree need to be modified.
The following instructions are executed under Helios4.

### Prerequisites

* Helios4 Linux Kernel Source Code
* Build Essentials package

Install the dependencies and extract the source into ~/src/linux

```
sudo apt-get -y install build-essential linux-source-4.14.87-next-mvebu
mkdir -p ~/src/linux
tar Jxf /usr/src/linux-source-$(uname -r).tar.xz -C ~/src/linux
```

!!! note
    You will need to choose the right *linux-source* package that matches the kernel version you are running. Check kernel version with command **uname -r**.

### Patching and Compilation

Download and apply [this patch](/helios4/files/sdcard/helios4_dtb_sd_uhs_linux_stable.patch) to Linux kernel source code.

```
cd ~/src/linux

wget https://wiki.kobol.io/helios4/files/sdcard/helios4_dtb_sd_uhs_linux_stable.patch
git apply --apply --verbose helios4_dtb_sd_uhs_linux_stable.patch
```

Compile the device tree into dtb

```
cp /boot/config-$(uname -r) .config
make armada-388-helios4.dtb
cp arch/arm/boot/dts/armada-388-helios4.dtb armada-388-helios4.dtb.uhs
```

!!! Info
    Precompiled dtb for Linux kernel 4.14 can be found [here](/helios4/files/sdcard/armada-388-helios4.dtb.uhs)

Copy new dtb to /boot/dtb/, backup the original dtb and create symlink to new dtb

```
sudo cp armada-388-helios4.dtb.uhs /boot/dtb/
cd /boot/dtb/
sudo cp armada-388-helios4.dtb armada-388-helios4.dtb.ori
sudo ln -sf armada-388-helios4.dtb.uhs armada-388-helios4.dtb
```

Reboot the system.


## Recovery

If the system become unbootable after applying modified dtb, recover the system by [connecting to Helios4 serial console](/helios4/install/#step-4-connect-to-helios4-serial-console)
and run following commands

```
setenv fdt_addr 0x2040000
setenv bootargs "console=ttyS0,115200 root=/dev/mmcblk0p1 rootwait rootfstype=ext4 ubootdev=mmc scandelay ignore_loglevel"

load mmc 0:1 ${fdt_addr} /boot/dtb/armada-388-helios4.dtb.ori
load mmc 0:1 ${ramdisk_addr_r} /boot/uInitrd
load mmc 0:1 ${kernel_addr_r} /boot/zImage

setenv fdt_high 0xffffffff
setenv initrd_high 0xffffffff

bootz ${kernel_addr_r} ${ramdisk_addr_r} ${fdt_addr}
```

After successfully boot to Linux, restore the original dtb and remove the modified one.

```
sudo mv -f /boot/dtb/armada-388-helios4.dtb.ori /boot/dtb/armada-388-helios4.dtb
sudo rm /boot/dtb/armada-388-helios4.dtb.uhs
```


## Performance Testing

The test methodology is adapted from
[SD card performance - Research guides & tutorials - Armbian forum](https://forum.armbian.com/topic/954-sd-card-performance/)
with slightly modified parameter to run the test on SD card mounted under /mnt/sdcard.

```
iozone -e -I -a -s 100M -r 4k -r 16k -r 512k -r 1024k -r 16384k -i 0 -i 1 -i 2 -f /mnt/sdcard/iozone-test.dat
```

To automate the test, a test script named [run_sdcard_test.sh](/helios4/files/sdcard/run_sdcard_test.sh) was created.

### Test Procedure

**1.** Prepare the system to boot from SPI and Rootfs located on USB drive. See [SPI (NOR Flash) page](/helios4/spi/).

**2.** Build and replace Helios4 dtb as instructed in [Device Tree Modification](#device-tree-modification).

**3.** Install iozone and download the test script

```
sudo apt-get -y install iozone3

wget https://wiki.kobol.io/helios4/files/sdcard/run_sdcard_test.sh
chmod 755 run_sdcard_test.sh

```

**4.** Override kernel loglevel on every boot

```
sudo sed -i 's/^exit 0/dmesg -n 8\nexit 0/g' /etc/rc.local
```

**5.** Make sure armada-388-helios4.dtb points to armada-388-helios4.dtb.uhs

```
cd /boot/dtb/
sudo ln -sf armada-388-helios4.dtb.uhs armada-388-helios4.dtb
```

**6.** Reboot and cancel U-Boot autoboot.

**7.** Read SD card info and boot to Linux

```
mmc rescan
mmc info
bootd
```

**8.** Observe whether any error/warning on sd card detection in console and check whether sdcard is detected.

```
dmesg | grep "mmc"
lsblk
```

**9.** Run the test script

```
sudo ./run_sdcard_test.sh
```

The test script will display the test progress and log result into log file : *SD_test_**<sdcard_address\>**\_[**<sdcard_name\>**]\_**<date_in_YYYYMMDD_HHMMSS\>**.log*

Example filename: SD_test_mmc0:aaaa-[SU08G]_20181212_034241.log

If the SD card is not detected, the test script would exit without saving any log file.

**10.** Change armada-388-helios4.dtb to point back to armada-388-helios4.dtb.ori

```
cd /boot/dtb/
sudo ln -sf armada-388-helios4.dtb.ori armada-388-helios4.dtb
```

**11.** Repeat step **6** until **9** to test in Normal Speed mode.

**12.** Repeat step **5** until **11** for other card.

**13.** Remove kernel loglevel override done in step **4**.

```
sudo sed -i '/^dmesg -n 8/d' /etc/rc.local
```

### Tested MicroSD Card

Below a non-exhaustive list of microSD Card models that we tested to check compatibility with UHS-I speed mode. We will keep populating this list with new microSD Card models.

| **MicroSD Card Model** | **UHS-I Compatibility Result** |
|--------------------|----------------|
| [Kingston Mobile Card microSDHC (16GB)](#kingston-mobile-card-microsdhc-16gb)|not compatible|
| [Samsung microSDHC UHS-I Card EVO Plus (32GB)](#samsung-microsdhc-uhs-i-card-evo-plus-32gb)|**yes, but no performance improvement if used as boot drive**|
| [SanDisk Extreme microSDHC UHS-I Card (32GB)](#sandisk-extreme-microsdhc-uhs-i-card-32gb)|**yes, performance boosted**|
| [SanDisk Extreme PRO microSDHC UHS-I Card (32GB)](#sandisk-extreme-pro-microsdhc-uhs-i-card-32gb)|**yes, performance boosted**|
| [SanDisk Ultra microSD UHS-I Card (32GB)](#sandisk-ultra-microsd-uhs-i-card-32gb)|**yes, but no performance improvement**|
| [SanDisk Ultra microSD UHS-I Card (16GB)](#sandisk-ultra-microsd-uhs-i-card-16gb)|not compatible|
| [SanDisk Ultra microSD UHS-I Card 48MBps (16GB)](#sandisk-ultra-microsd-uhs-i-card-48mbps-16gb)|not compatible|
| [SanDisk Ultra microSD UHS-I Card 30MBps (8GB)](#sandisk-ultra-microsd-uhs-i-card-30mbps-8gb)|**yes, but no performance improvement**|
| [Strontium Nitro MicroSD Card (16GB)](#strontium-nitro-microsd-card-16gb)|**yes, performance boosted**|
| [Toshiba MicroSD Exceria Pro (16GB)](#toshiba-microsd-exceria-pro-16gb)|not compatible|
| [Transcend microSDHC Premium (8GB)](#transcend-microsdhc-premium-8gb)|**yes, but no performance improvement**|

#### Kingston Mobile Card microSDHC (16GB)

![Kingston microSDHC 16GB](/helios4/img/sdcard/kingston_16gb.jpg)

*Specifications*

|  |  |
| -----|------|
| Product Page | [https://www.kingston.com/en/flash/microsd_cards/sdc10g2](https://www.kingston.com/en/flash/microsd_cards/sdc10g2) |
| Manufacture Id | 0x00009f |
| OEM ID | 0x5449 |
| Product Name | SD16G |
| HW Revision | 0x3 |
| FW Revision | 0x0 |
| Serial Number | 0x5b3003c7 |
| Manufacture Date | 07/2018 |
| Capacity Standard | SDHC |
| SD version* | 1.0 |
| Mode* | SD Legacy |
| Bus Speed* | 25000000 |
| Bus Width* | 4-bit |

!!! Notes
    * Value taken from U-Boot "mmc info".

*Test Result* : Failed!

```
mmc0: new SDHC card at address 0001
mmcblk0: mmc0:0001 SD16G 14.6 GiB
 mmcblk0: p1
```

The card was detected by Linux but when the test runnning, kernel console constantly emits

```
mmcblk0: error -110 transferring data, sector 2433024, nr 1024, cmd response 0x900, card status 0xb00
mmcblk0: retrying using single block read
mmc0: Timeout waiting for hardware interrupt.
mmc0: sdhci: ============ SDHCI REGISTER DUMP ===========
mmc0: sdhci: Sys addr:  0x00000000 | Version:  0x00000202
mmc0: sdhci: Blk size:  0x00007200 | Blk cnt:  0x00000030
mmc0: sdhci: Argument:  0x00252400 | Trn mode: 0x00000033
mmc0: sdhci: Present:   0x01e70206 | Host ctl: 0x00000011
mmc0: sdhci: Power:     0x0000000f | Blk gap:  0x00000000
mmc0: sdhci: Wake-up:   0x00000000 | Clock:    0x0000fa07
mmc0: sdhci: Timeout:   0x00000003 | Int stat: 0x00000000
mmc0: sdhci: Int enab:  0x02ff008b | Sig enab: 0x02ff008b
mmc0: sdhci: AC12 err:  0x00000000 | Slot int: 0x00000000
mmc0: sdhci: Caps:      0x25fcc8b2 | Caps_1:   0x00002f77
mmc0: sdhci: Cmd:       0x0000123a | Max curr: 0x00000000
mmc0: sdhci: Resp[0]:   0x00000900 | Resp[1]:  0x47305b30
mmc0: sdhci: Resp[2]:   0x53443136 | Resp[3]:  0x009f5449
mmc0: sdhci: Host ctl2: 0x00000008
mmc0: sdhci: ADMA Err:  0x00000000 | ADMA Ptr: 0x7f0b95d0
mmc0: sdhci: ============================================
mmcblk0: error -110 transferring data, sector 2434048, nr 1024, cmd response 0x900, card status 0xb00
mmc0: Timeout waiting for hardware interrupt.
```

And the still did not finished the test after 8 hours.

---

#### Samsung microSDHC UHS-I Card EVO Plus (32GB)

![Samsung EVO Plus 32GB](/helios4/img/sdcard/samsung_evo_plus_32gb.jpg)

*Specifications*

|  |  |
| -----|------|
| Product Page | [https://www.samsung.com/us/computing/memory-storage/memory-cards/microsdhc-evo-plus-memory-card-w--adapter-32gb--2017-model--mb-mc32ga-am/](https://www.samsung.com/us/computing/memory-storage/memory-cards/microsdhc-evo-plus-memory-card-w--adapter-32gb--2017-model--mb-mc32ga-am/) |
| Manufacture Id | 0x00001b |
| OEM ID | 0x534d |
| Product Name | EB1QT |
| HW Revision | 0x3 |
| FW Revision | 0x0 |
| Serial Number | 0x6d4061eb |
| Manufacture Date | 06/2018 |
| Capacity Standard | SDHC |
| SD version* | 3.0 |
| Mode* | SD High Speed (50MHz) |
| Bus Speed* | 50000000 |
| Bus Width* | 4-bit |

!!! Notes
    * Value taken from U-Boot "mmc info".

*Test Result*

```
[    3.428116] mmc0: new high speed SDHC card at address 0001
[    3.434040] mmcblk0: mmc0:0001 EB1QT 29.8 GiB
[    3.517590]  mmcblk0: p1
[   48.452996] mmc0: card 0001 removed
[   50.155681] mmc0: new ultra high speed DDR50 SDHC card at address 0001
[   50.162494] mmcblk0: mmc0:0001 EB1QT 29.8 GiB
[   50.169200]  mmcblk0: p1
```

Card speed stays at high speed during boot up while other UHS-I compatible card switched to ultra high speed.
It only changed to ultra high speed after remove and reinsert the card.

If the card is used as boot/system drive, it is not allowed to be removed during runtime therefore no performance gain since the speed stays at high speed.

![!Samsung EVO Plus 32GB Test Result](/helios4/img/sdcard/test_result_samsung_evo_plus_32gb.png)

---

#### SanDisk Extreme microSDHC UHS-I Card (32GB)

![SanDisk Extreme 32GB](/helios4/img/sdcard/sandisk_extreme_32gb.png)

*Specifications*

|  |  |
| -----|------|
| Product Page | [https://www.sandisk.com/home/memory-cards/microsd-cards/extreme-microsd](https://www.sandisk.com/home/memory-cards/microsd-cards/extreme-microsd) |
| Manufacture Id | 0x000003 |
| OEM ID | 0x5344 |
| Product Name | SM32G |
| HW Revision | 0x8 |
| FW Revision | 0x0 |
| Serial Number | 0x4313d13b |
| Manufacture Date | 10/2018 |
| Capacity Standard | SDHC |
| SD version* | 3.0 |
| Mode* | SD High Speed (50MHz) |
| Bus Speed* | 50000000 |
| Bus Width* | 4-bit |

!!! Notes
    * Value taken from U-Boot "mmc info".

*Test Result*

```
mmc0: new ultra high speed DDR50 SDHC card at address aaaa
mmcblk0: mmc0:aaaa SM32G 29.7 GiB
 mmcblk0: p1
```


![!SanDisk Extreme 32GB Test Result](/helios4/img/sdcard/test_result_sandisk_extreme_32gb.png)

---

#### SanDisk Extreme PRO microSDHC UHS-I Card (32GB)

![SanDisk Extreme PRO 32GB](/helios4/img/sdcard/sandisk_extreme_pro_32gb.png)

*Specifications*

|  |  |
| -----|------|
| Product Page | [https://www.sandisk.com/home/memory-cards/microsd-cards/extremepro-microsd](https://www.sandisk.com/home/memory-cards/microsd-cards/extremepro-microsd) |
| Manufacture Id | 0x000003 |
| OEM ID | 0x5344 |
| Product Name | SP32G |
| HW Revision | 0x8 |
| FW Revision | 0x0 |
| Serial Number | 0x122a8270 |
| Manufacture Date | 10/2017 |
| Capacity Standard | SDHC |
| SD version* | 3.0 |
| Mode* | SD High Speed (50MHz) |
| Bus Speed* | 50000000 |
| Bus Width* | 4-bit |

!!! Notes
    * Value taken from U-Boot "mmc info".

*Test Result*

```
mmc0: new ultra high speed DDR50 SDHC card at address e624
mmcblk0: mmc0:e624 SP32G 29.7 GiB
 mmcblk0: p1
```


![!SanDisk Extreme PRO 32GB Test Result](/helios4/img/sdcard/test_result_sandisk_extreme_pro_32gb.png)

---

#### SanDisk Ultra microSD UHS-I Card (32GB)

![SanDisk Ultra smartphone 32GB](/helios4/img/sdcard/sandisk_ultra_uhs-i_for_smartphone_32gb.jpg)

*Specifications*

|  |  |
| -----|------|
| Product Page | [https://www.sandisk.com/home/memory-cards/microsd-cards/ultra-microsd-for-smartphones](https://www.sandisk.com/home/memory-cards/microsd-cards/ultra-microsd-for-smartphones) |
| Manufacture Id | 0x000003 |
| OEM ID | 0x5344 |
| Product Name | SL32G |
| HW Revision | 0x8 |
| FW Revision | 0x0 |
| Serial Number | 0x0c9daa71 |
| Manufacture Date | 04/2014 |
| Capacity Standard | SDHC |
| SD version* | 3.0 |
| Mode* | SD High Speed (50MHz) |
| Bus Speed* | 50000000 |
| Bus Width* | 4-bit |

!!! Notes
    * Value taken from U-Boot "mmc info".

*Test Result*

```
mmc0: new ultra high speed DDR50 SDHC card at address aaaa
mmcblk0: mmc0:aaaa SL32G 29.7 GiB
 mmcblk0: p1
mmc0: Tuning failed, falling back to fixed sampling clock
mmcblk0: error -84 transferring data, sector 62333824, nr 8, cmd response 0x900, card status 0xb00
```

Even though there are some errors, the test finished without much improvement.

![!SanDisk Ultra smartphone 32GB Test Result](/helios4/img/sdcard/test_result_sandisk_ultra_uhs-i_for_smartphone_32gb.png)

---

#### SanDisk Ultra microSD UHS-I Card (16GB)

![SanDisk Ultra smartphone 16GB](/helios4/img/sdcard/sandisk_ultra_uhs-i_for_smartphone_16gb.jpg)

*Specifications*

|  |  |
| -----|------|
| Product Page | [https://www.sandisk.com/home/memory-cards/microsd-cards/ultra-microsd-for-smartphones](https://www.sandisk.com/home/memory-cards/microsd-cards/ultra-microsd-for-smartphones) |
| Manufacture Id | 0x000003 |
| OEM ID | 0x5344 |
| Product Name | SL16G |
| HW Revision | 0x8 |
| FW Revision | 0x0 |
| Serial Number | 0xa5253c77 |
| Manufacture Date | 04/2017 |
| Capacity Standard | SDHC |
| SD version* | 3.0 |
| Mode* | SD High Speed (50MHz) |
| Bus Speed* | 50000000 |
| Bus Width* | 4-bit |

!!! Notes
    * Value taken from U-Boot "mmc info".

*Test Result* : Failed!

```
mmc0: new ultra high speed DDR50 SDHC card at address aaaa
mmcblk0: mmc0:aaaa SL16G 14.8 GiB
mmcblk0: error -84 sending status command, retrying
mmc0: Tuning failed, falling back to fixed sampling clock
mmcblk0: error -84 sending status command, retrying
mmc0: Tuning failed, falling back to fixed sampling clock
mmcblk0: error -84 sending status command, aborting
mmc0: Tuning failed, falling back to fixed sampling clock
mmcblk0: unable to read partition table
mmc0: card aaaa removed
mmc0: new high speed SDHC card at address aaaa
mmcblk0: mmc0:aaaa SL16G 14.8 GiB
mmcblk0: error -84 sending status command, retrying
mmcblk0: error -84 sending stop command, original cmd response 0x900, card status 0x900
mmcblk0: error -84 transferring data, sector 0, nr 8, cmd response 0x900, card status 0x0
mmcblk0: error -84 sending stop command, original cmd response 0x900, card status 0x900
mmcblk0: error -84 transferring data, sector 0, nr 8, cmd response 0x900, card status 0x0
```

The card was not detected by Linux.

---

#### SanDisk Ultra microSD UHS-I Card 48MBps (16GB)

![SanDisk Ultra 48MBps](/helios4/img/sdcard/sandisk_ultra_uhs-i_48mbps_16gb.jpg)

*Specifications*

|  |  |
| -----|------|
| Product Page | [https://www.sandisk.com/home/memory-cards/microsd-cards/ultra-microsd-48mbs](https://www.sandisk.com/home/memory-cards/microsd-cards/ultra-microsd-48mbs) |
| Manufacture Id | 0x000003 |
| OEM ID | 0x5344 |
| Product Name | SL16G |
| HW Revision | 0x8 |
| FW Revision | 0x0 |
| Serial Number | 0x349f2b91 |
| Manufacture Date | 01/2016 |
| Capacity Standard | SDHC |
| SD version* | 3.0 |
| Mode* | SD High Speed (50MHz) |
| Bus Speed* | 50000000 |
| Bus Width* | 4-bit |

!!! Notes
    * Value taken from U-Boot "mmc info".

*Test Result* : Failed!

```
mmc0: new ultra high speed DDR50 SDHC card at address aaaa
mmcblk0: mmc0:aaaa SL16G 14.8 GiB
mmc0: Tuning failed, falling back to fixed sampling clock
mmcblk0: error -84 transferring data, sector 0, nr 8, cmd response 0x900, card status 0xb00
 mmcblk0: p1
mmcblk0: error -84 transferring data, sector 10240, nr 8, cmd response 0x900, card status 0xb00
mmcblk0: error -84 transferring data, sector 8784, nr 72, cmd response 0x900, card status 0xb00
mmcblk0: error -84 transferring data, sector 8784, nr 72, cmd response 0x900, card status 0xb00
mmcblk0: retrying using single block read
mmcblk0: error -84 transferring data, sector 8856, nr 360, cmd response 0x900, card status 0xb00
mmcblk0: error -84 transferring data, sector 8856, nr 360, cmd response 0x900, card status 0xb00
```

The card was not detected by Linux.

---

#### SanDisk Ultra microSD UHS-I Card 30MBps (8GB)

![SanDisk Ultra 30 MBps](/helios4/img/sdcard/sandisk_ultra_uhs-i_8gb.jpg)

*Specifications*

|  |  |
| -----|------|
| Product Page | [https://www.sandisk.com/home/memory-cards/microsd-cards/ultra-microsd-for-smartphones](https://www.sandisk.com/home/memory-cards/microsd-cards/ultra-microsd-for-smartphones) |
| Manufacture Id | 0x000003 |
| OEM ID | 0x5344 |
| Product Name | SU08G |
| HW Revision | 0x8 |
| FW Revision | 0x0 |
| Serial Number | 0x2369e07f |
| Manufacture Date | 12/2013 |
| Capacity Standard | SDHC |
| SD version* | 3.0 |
| Mode* | SD High Speed (50MHz) |
| Bus Speed* | 50000000 |
| Bus Width* | 4-bit |

!!! Notes
    * Value taken from U-Boot "mmc info".

*Test Result*

```
mmc0: new ultra high speed DDR50 SDHC card at address aaaa
mmcblk0: mmc0:aaaa SU08G 7.40 GiB
mmc0: Tuning failed, falling back to fixed sampling clock
mmcblk0: error -84 transferring data, sector 0, nr 8, cmd response 0x900, card status 0xb00
 mmcblk0: p1
```

Even though there are some errors, the test finished. Many of test cases see performance reduction.

![!SanDisk Ultra 30 MBps Test Result](/helios4/img/sdcard/test_result_sandisk_ultra_uhs-i_8gb.png)

---

#### Strontium Nitro MicroSD Card (16GB)

![Strontium](/helios4/img/sdcard/strontium_nitro_16gb.jpg)

*Specifications*

|  |  |
| -----|------|
| Product Page | [http://www.strontium.biz/products/memory-cards/mobile-memory-cards/#seven](http://www.strontium.biz/products/memory-cards/mobile-memory-cards/#seven) |
| Manufacture Id | 0x000084 |
| OEM ID | 0x5446 |
| Product Name | SD |
| HW Revision | 0x0 |
| FW Revision | 0x0 |
| Serial Number | 0x954b266b |
| Manufacture Date | 09/2016 |
| Capacity Standard | SDHC |
| SD version* | 3.0 |
| Mode* | SD High Speed (50MHz) |
| Bus Speed* | 50000000 |
| Bus Width* | 1-bit |

!!! Notes
    * Value taken from U-Boot "mmc info".

*Test Result*

```
mmc0: Tuning failed, falling back to fixed sampling clock
mmc0: new ultra high speed DDR50 SDHC card at address 0001
mmcblk0: mmc0:0001 SD 14.6 GiB
 mmcblk0: p1
mmc0: Tuning failed, falling back to fixed sampling clock
mmc0: Tuning failed, falling back to fixed sampling clock
```

Even though there are some warnings, the test finished.

![!Strontium Nitro Test Result](/helios4/img/sdcard/test_result_strontium_nitro_16gb.png)

---

#### Toshiba MicroSD Exceria Pro (16GB)


![Toshiba Exceria Pro](/helios4/img/sdcard/toshiba_exceria_pro_16gb.jpg)

*Specifications*

|  |  |
| -----|------|
| Product Page | [https://www.toshiba-memory.com/products/toshiba-microsd-cards-exceria-pro-m401/](https://www.toshiba-memory.com/products/toshiba-microsd-cards-exceria-pro-m401/) |
| Manufacture Id | 0x000002 |
| OEM ID | 0x544d |
| Product Name | UC0C5 |
| HW Revision | 0x5 |
| FW Revision | 0x0 |
| Serial Number | 0xd2a0e6a3 |
| Manufacture Date | 11/2016 |
| Capacity Standard | SDHC |
| SD version* | 3.0 |
| Mode* | SD High Speed (50MHz) |
| Bus Speed* | 50000000 |
| Bus Width* | 4-bit |

!!! Notes
    * Value taken from U-Boot "mmc info".

*Test Result* : Failed!

```
mmc0: error -84 whilst initialising SD card
```

The card was not detected by Linux.

---

#### Transcend microSDHC Premium (8GB)

![Transcend](/helios4/img/sdcard/transcend_premium_8gb.jpg)

*Specifications*

|  |  |
| -----|------|
| Product Page | [https://www.transcend-info.com/Products/No-320](https://www.transcend-info.com/Products/No-320) |
| Manufacture Id | 0x000074 |
| OEM ID | 0x4a45 |
| Product Name | USD |
| HW Revision | 0x1 |
| FW Revision | 0x0 |
| Serial Number | 0x4568e585 |
| Manufacture Date | 06/2014 |
| Capacity Standard | SDHC |
| SD version* | 3.0 |
| Mode* | SD High Speed (50MHz) |
| Bus Speed* | 50000000 |
| Bus Width* | 1-bit |

*Test Result*

```
mmc0: new high speed SDHC card at address b368
mmcblk0: mmc0:b368 USD   7.45 GiB
 mmcblk0: p1
```

![!Transcend Premium Test Result](/helios4/img/sdcard/test_result_transcend_premium_8gb.png)

---

**Value taken from U-Boot "mmc info"*
