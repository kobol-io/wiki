
## Problem: Could not connect to Helios64

### Faulty Power Supply

Verify whether [LED1](/helios64/led/) is turned on. If not tighten PSU cable.

If problem still occurs, replace the PSU.

### OS Failure

Verify whether [System Activity LED](/helios64/front-panel/#helios64-enclosure) is blinking. If it is not, reset or power cycle.

If problem still occurs, please capture the serial console output and report it to forum.

### Kernel Panic

If [System Error LED](/helios64/front-panel/#helios64-enclosure) blinking, there was kernel panic. Please reset the system.

If problem still occurs, please capture the serial console output and report it to forum.

### Network down

Verify whether Ethernet LED turned on. If it is not, try to unplug and re-plug the network cable.

If network still down, try other Ethernet port.

### Corrupted filesystem

Boot from micro SD card and execute following command to repair system partition on eMMC

```
fsck -p /dev/mmcblk1p1
```
or
```
btrfs check --repair /dev/mmcblk1p1
```
if your system partition formatted with BTRFS.

### Micro SD card slot broken

Try to flash OS directly to eMMC using [maskrom mode](/helios64/maskrom/)

### Old bootloader

On October 5th, 2020 there was device tree (dtb) filename change. It applied to Armbian 20.08.8.
Originally the filename is **rk3399-helios64.dtb** and changed into **rk3399-kobol-helios64.dtb**

Boot from micro SD card and execute following commands

```
sudo mkdir -p /mnt/system
sudo mount /dev/mmcblk1p1 /mnt/system
sudo ln -sf rk3399-kobol-helios64.dtb /mnt/system/boot/dtb/rockchip/rk3399-helios64.dtb
sudo umount /mnt/system
sudo poweroff
```

Remove the micro SD card and power on the system.

After boot successfully to eMMC, we strongly suggest to update the bootloader using armbian-config.

### Rootfs is not accessible

If you have transfer the rootfs to SATA or USB, make sure the device is still accessible and you don't remove the device.

Boot from micro SD card and execute following command,

```
sudo mkdir -p /mnt/system
sudo mount /dev/mmcblk1p1 /mnt/system
grep "rootdev" /mnt/system/boot/armbianEnv.txt
```
Take note of UUID value and run,

```
sudo blkid
```
Verify if you have device with the same UUID. If the device is accessible, it might have corrupted filesystem. Run *fsck* to check and fix it.

---

## Problem: Serial console does not appear

### Driver not installed

Make sure you have FTDI VCP driver installed. You can download the driver from [FTDI Website](https://www.ftdichip.com/Drivers/VCP.htm)

### Jumper P13 closed

Make sure jumper P13 is open otherwise it will disable the built-in USB to Serial converter. Refer to [USB Console/Recovery Mode (P13)](/helios64/jumper/#usb-consolerecovery-mode-p13)

### Cable is not plugged correctly

When you put the back panel make sure to align the port and push a bit before securing with screw.

![! backpanel connector](/helios64/img/troubleshoot/backplate_connector.jpg)

If the USB-C port cannot hold the cable properly and loose the cable, you need to shave the cable a bit so the plastic does not touch the back panel.

![! usb cable](/helios64/img/troubleshoot/usb_cable_shaved.jpg)

Photo from [TDCroPower at Armbian Forum](https://forum.armbian.com/topic/15431-helios64-support/page/4/?tab=comments#comment-110859)

---

## Problem: I have broken bootloader on eMMC and unable to boot, how to force boot from micro SD ?

Make sure the system is powered off and insert the micro SD card.
Short [P10](/helios64/jumper/#boot-mode-p10-p11) with jumper cap, power on and remove the jumper cap before boot Linux (~5 seconds after power on).

## Problem: How to clean up the eMMC

### System still booting from eMMC after deleting the partition

Bootloader located between first block and first partition. Clearing partition table does not remove the bootloader.

Execute following command to erase Partition table, bootloader and partition superblock.

```
sudo dd if=/dev/zero of=/dev/mmcblk1 bs=512 count=65535
sudo sync
```

