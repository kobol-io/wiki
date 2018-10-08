The A388 System-On-Module used by Helios4 provides an SPI NOR flash [Winbond W25Q32BV](https://media.digikey.com/pdf/Data%20Sheets/Winbond%20PDFs/W25Q32BV.pdf) connected to SPI bus 1 Chip Select 0.

By default, Helios4 is configured to boot from microSD card. To boot from SPI NOR flash (after [writing U-Boot into SPI NOR flash](#write-u-boot-to-spi-nor-flash)), please change Boot Mode on DIP Switch **SW1** to:

![Boot from SPI](/img/spi/dipswitch_boot_spinor.png)


## Build U-Boot for SPI NOR flash

Refer to [U-Boot](/uboot) page to build the image.

*A prebuilt SPI image of U-Boot 2013.01 for Armbian OS can be downloaded from [here](/files/uboot/u-boot-armbian-2013.01-spi.bin).*

## Write U-Boot to SPI NOR flash

!!! important
    Concurrent access on SPI NOR and SATA drives can lead to unstable SATA. The following instructions has taken this issue into consideration and workaround it by disabling the SATA temporary.

### Under Armbian

1) Edit /boot/armbianEnv.txt and enable spi_workaround

`spi_workaround=on`

2) Reboot the system to apply the change

3) Log in to Helios4, verify whether mtdblock0 is present using **lsblk**

```
lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
mtdblock0    31:0    0    4M  0 disk
mmcblk0     179:0    0 14.9G  0 disk
└─mmcblk0p1 179:1    0 14.8G  0 part /
```

4) Run **nand-sata-install** utility

```
sudo nand-sata-install
```

5) Select option **5 Install the bootloader to SPI Flash**

6) If you want to take the opportunity to move your RootFS to another device, jump to this [section](#moving-rootfs-to-other-device). Otherwise you may disable spi_workaround in /boot/armbianEnv.txt

`spi_workaround=off`

7) Set DIP switches **SW1** to SPI Boot and reboot the system.

![Boot from SPI](/img/spi/dipswitch_boot_spinor.png)

### Under Generic Linux

!!! info
    You will need to access to Helios4 via Serial Console. Please refer to [Install](/install/#step-4-connect-to-helios4-serial-console) page for instructions.

1) Upload the U-Boot SPI binary that you built to Helios4 and rename it as **u-boot-spi.bin**.

2) Download boot_spi_en.scr from [here](/files/uboot/boot_spi_en.scr) and put it to /boot/.

```
sudo wget https://wiki.kobol.io/files/uboot/boot_spi_en.scr -O /boot/boot_spi_en.scr
```

*Source code of boot_spi_en.scr can be found [here](/files/uboot/boot_spi_en.cmd).*

3) Switch to Helios4 serial console, then reboot the system

```
sudo Reboot
```

4) Press any key to cancel the U-Boot autoboot and execute these commands

```
setenv script_name "/boot/boot_spi_en.scr"
stage_boot mmc_scr
```

It will boot to Linux with modified device tree.

5) Log in to Helios4, verify whether mtdblock0 is present using **lsblk**

```
lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
mtdblock0    31:0    0    4M  0 disk
mmcblk0     179:0    0 14.9G  0 disk
└─mmcblk0p1 179:1    0 14.8G  0 part /
```

6) Write the U-Boot binary to SPI flash using this command

```
sudo dd if=~/u-boot-spi.bin of=/dev/mtdblock0
```

7) Set DIP switches **SW1** to SPI Boot and reboot the system.

![Boot from SPI](/img/spi/dipswitch_boot_spinor.png)

Observe the first lines of boot message on serial console, it should display

```
BootROM - 1.73
Booting from SPI flash
```

## Set Up U-Boot Environment

!!! important
    Prebuilt SPI images for Armbian are configured to automatically run /boot/boot.scr on microSD or USB drive. There is no need to set up u-boot environment to boot Armbian.

Add U-Boot ENV variables to prevent U-Boot to relocate fdt and initrd into RAM address that is not accessible by kernel, and set the correct device tree name for Helios4 board

```
setenv fdt_high 0xffffffff
setenv initrd_high 0xffffffff
setenv fdtfile armada-388-helios4.dtb
saveenv
```

- To automatically boot Linux on microSD card

```
setenv bootargs '${console} root=/dev/mmcblk0p1 rootwait'
setenv bootcmd 'ext2load mmc 0:1 ${kernel_addr_r} /boot/zImage; ext2load mmc 0:1 ${ramdisk_addr_r} /boot/uInitrd; ext2load mmc 0:1 ${fdt_addr} /boot/dtb/${fdtfile}; bootz ${kernel_addr_r}  ${ramdisk_addr_r} ${fdt_addr}'
saveenv
```

- To automatically boot Linux on USB drive (assume UUID=1234)

```
setenv bootargs '${console} root=UUID=1234 rootwait'
setenv bootcmd 'usb start; ext2load usb 0:1 ${kernel_addr_r} /boot/zImage; ext2load usb 0:1 ${ramdisk_addr_r} /boot/uInitrd; ext2load usb 0:1 ${fdt_addr} /boot/dtb/${fdtfile}; bootz ${kernel_addr_r}  ${ramdisk_addr_r} ${fdt_addr}'
saveenv
```

## Moving RootFS to Other Device

Now you have the option to move your Root FileSystem to a storage device connected to USB3.0. Under Armbian you can use the **nand-sata-install** utility to easily take care of this procedure.

1) Enable the *spi_workaround* if it's not enabled yet (refer to the above [section](#under-armbian)).

2) Run **nand-sata-install** utility
```
sudo nand-sata-install
```

3) Select option **6 Boot from SPI - system on SATA, USB or NVMe**

!!! Important
    The target device you want to use to host your RootFS should be already partitioned.
    **Warning** All data present on the partition you choose will be erased.

4) When RootFS migration is done, disable spi_workaround.

5) Set DIP switches **SW1** to SPI Boot and reboot the system.

6) Check that your system has mounted the RootFS from the correct device.
*It shouldn't be /dev/mmcblk0p1*

```
grep '/ ' /proc/mounts
/dev/sdb1 / ext4 rw,noatime,nodiratime,errors=remount-ro,commit=600 0 0
```

You can now remove your microSD Card. However you should keep it aside, it can be useful in case you need to recover your system.
