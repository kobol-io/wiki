
## Problem: Could not connect to Helios64

### Faulty Power Supply

Verify whether [LED1](/helios64/led/) is turned on. If not tighten PSU cable.

If problem still occurs, replace the PSU.

### OS Failure

Verify whether [System Activity LED](/helios64/front-panel/#helios64-enclosure) is blinking. If it is not, reset or power cycle.

If problem still occurs, please capture the serial console output and report it to forum.

### Kernel Panic

If [System Error LED](/helios64/front-panel/#helios64-enclosure) blinking, there was kernel panic.

If problem still occurs, please capture the serial console output and report it to forum.

### Network down

#### Solution 1

Verify whether Ethernet LED turned on. If it is not, try to unplug and re-plug the network cable.

#### Solution 2

Try other Ethernet port.

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

---

## Problem: Serial console does not appear

### Driver not installed

Make sure you have FTDI VCP driver installed. You can download the driver from [FTDI Website](https://www.ftdichip.com/Drivers/VCP.htm)

### Jumper P13 closed

Make sure jumper P13 is open otherwise it will disable the built-in USB to Serial converter. Refer to [USB Console/Recovery Mode (P13)](/helios64/jumper/#usb-consolerecovery-mode-p13)

