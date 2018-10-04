## Hardware

System-On-Module used by Helios4 provide an SPI NOR flash [Winbond W25Q32](https://www.winbond.com/hq/product/code-storage-flash-memory/serial-nor-flash/?__locale=en&selected=32Mb#Density) connected to SPI bus 1 Chip Select 0.

By default, Helios4 configured to boot from microSD card. To boot from SPI NOR flash (after [writing U-Boot into SPI NOR flash](#write-u-boot-to-spi-nor-flash)), please change Boot Mode DIP switch SW1 to:

![Boot from SPI](/img/hardware/dipswitch_boot_spinor.png)


## Build U-Boot for SPI NOR flash

Refer to [U-Boot](/uboot) page to build the image.

!!! info
    Prebuilt SPI image of U-Boot 2013.01 can be downloaded from [here](/files/software/u-boot-2013.01-spi.bin).

## Write U-Boot to SPI NOR flash

### Prerequisites

1. Access to Helios4 Serial Console. Please refer to [Install](/install/#step-4-connect-to-helios4-serial-console) page for instructions.

2. Bootable U-Boot on microSD card.

### Using Linux

!!! info
    Concurrent access on SPI NOR and SATA drive can lead to unstable SATA. The following instructions has taken this issue into consideration and workaround it by disabling the SATA temporary.

Put u-boot binaries on home folder and rename it as **u-boot-spi.bin**.
Download boot_spi_en.scr from [here](/files/software/boot_spi_en.scr) and put it to / and then reboot the system
```
sudo wget https://wiki.kobol.io/files/software/boot_spi_en.scr -O /boot_spi_en.scr
sudo reboot
```

Switch to Helios4 serial console. Press any key to cancel the autoboot and execute these commands
```
setenv script_name "boot_spi_en.scr"
stage_boot mmc_scr
```
It will boot to Linux with modified device tree.

- - -

Log in to Helios4, verify whether mtdblock0 is exist using **lsblk**, and write the u-boot to SPI flash using this command

```
sudo dd if=~/u-boot-spi.bin of=/dev/mtdblock0
```

Set DIP switches SW1 to SPI Boot

![Boot from SPI](/img/hardware/dipswitch_boot_spinor.png)

and reboot the system.
Observe the boot message on serial console, it should display

```
BootROM - 1.73
Booting from SPI flash
```

## Set Up U-Boot

Add U-Boot ENV variable.

```
setenv fdt_high 0xffffffff
setenv initrd_high 0xffffffff
setenv fdtfile armada-388-helios4.dtb
saveenv
```

To automatically boot Linux on microSD card

```
setenv bootargs '${console} root=/dev/mmcblk0p1 rootwait'
setenv bootcmd 'ext2load mmc 0:1 ${kernel_addr_r} /boot/zImage; ext2load mmc 0:1 ${ramdisk_addr_r} /boot/uInitrd; ext2load mmc 0:1 ${fdt_addr} /boot/dtb/${fdtfile}; bootz ${kernel_addr_r}  ${ramdisk_addr_r} ${fdt_addr}'
saveenv
```

!!! info
    The prebuilt SPI image has been configured to automatically run /boot/boot.scr and /boot.scr on microSD. There is no need to configure u-boot to boot Armbian on microSD.

