Maskrom is a special internal firmware of RK3399 that runs **Rockusb** driver automatically when there is no bootable firmware found on on-board storage such as SPI flash, eMMC or microSD card.

Maskrom mode can be your last resort if all other install approaches are not working for you.

On Helios64, there are two ways to force the maskrom mode:

- Disable SPI flash and eMMC according to [Boot Mode Jumper](/helios64/jumper/#boot-mode-p10-p11) and remove microSD card.

- Using [Recovery Button](/helios64/button/#maskrom-mode).

Rockusb is a vendor specific USB class from Rockchip to download firmware. This USB device has Vendor ID *0x2207* and Product ID *0x330c*.

!!! Info
    U-Boot has *rockusb* command, but it is not compatible with the Rockchip utilities

## Prerequisites

### RK3399 loader

  In maskrom mode, SoC initiliazed without DRAM and storage support therefore it needs a *loader* to initialized DRAM and prepare the flashing environment.

  Download the loader *rk3399_loader_v1.24_RevNocRL.126.bin* from [here](/helios64/files/maskrom/rk3399_loader_v1.24_RevNocRL.126.bin)

### Helios64 OS image

You will also need to download an OS image to write to the internal eMMC.

Go to [Download](/download/#helios64) and chose one of the latest build.

!!! important
    * OMV (OpenMediaVault) is only supported on Debian OS.
    * Armbian 20.08.8 and earlier version has bug that prevent system to boot from eMMC!

### Windows

!!! Info
    Latest version of the tools can be downloaded from [Rockchip GitHub](https://github.com/rockchip-linux/tools/tree/master/windows).

#### Rockusb driver

Download and extract *DriverAssistant_v4.91.zip* from [here](/helios64/files/maskrom/DriverAssitant_v4.91.zip).

Run *DriverInstall.exe* under the extracted folder and press *Install Driver*.

#### AndroidTools

Download and extract *AndroidTool_Release_v2.71.zip* from [here](/helios64/files/maskrom/AndroidTool_Release_v2.71.zip).

### Linux

Download prebuilt rkdevelop from [Rockchip GitHub](https://github.com/rockchip-linux/rkbin/archive/master.zip).
Extract the downloaded *rkbin-master.zip* file.

Copy *rk3399_loader_v1.24_RevNocRL.126.bin* to *rkbin-master* folder.

!!! Note
    - Prebuilt binaries have been tested on Ubuntu 18.04 and 20.04
    - You could also compile it from source by following instructions at [Rockchip Wiki](http://opensource.rock-chips.com/wiki_Rkdeveloptool).

## Write OS Image to eMMC

**1)** Make sure the system is powered off.

**2)** Put jumper cap to P13 to enable it.

![!Jumper P13](/helios64/img/maskrom/jumper_p13_enabled.jpg)

**3)** Plug in USB type-C cable to Helios64 and the other side to PC.

**4 a)** Disable SPI flash and eMMC according to [Boot Mode Jumper](/helios64/jumper/#boot-mode-p10-p11) and remove microSD card. Power on the system.

 or

**4 b)** Press and hold Recovery button. Power on the system and release recovery button after [System Activity LED](/helios64/front-panel/#helios64-enclosure) blink twice.

### Under Windows

**1.** Open Device Manager and verify whether rockusb device is recognized.

![rockusb on Device Manager](/helios64/img/maskrom/rockusb_device.png)

**2.** Run **AndroidTool.exe** and check whether there is **Found One MASKROM Device**.

![!AndroidTool Main Window](/helios64/img/maskrom/androidtools_00_main.png)

**3.** Click rows to load and select following files:

- Loader = rk3399_loader_v1.24_RevNocRL.126.bin

- Image = Helios64 OS image to write

!!! Warning
    The image must be Raw image, not in compressed form.

![!AndroidTool Files loaded](/helios64/img/maskrom/androidtools_01_ready_to_download.png)

**4.** Checklist both row and press **Run** button. Observer the log textbox.

![!AndroidTool Writing Images](/helios64/img/maskrom/androidtools_02_download_in_progress.png)

**5.** The log textbox will show **Download image OK** when finished and system will automatically reboot.

![!AndroidTool Writing Images](/helios64/img/maskrom/androidtools_03_done.png)

**6.** Remove jumper on P13, you should have USB Serial connected to your PC.

**7.** Continue to [setup the OS through Serial Console](/helios64/install/first-start/).

### Under Linux

**1.** Verify whether rockusb device is recognized.

```
lsusb -d 2207:330c
```

It should return something like:

`Bus 001 Device 014: ID 2207:330c Fuzhou Rockchip Electronics Company RK3399 in Mask ROM mode`

**2.** Open terminal under rkbin-master folder.

**3.** Send loader to Helios64

`sudo tools/rkdeveloptool db rk3399_loader_v1.24_RevNocRL.126.bin`

**4.** Write OS image to eMMC

`sudo tools/rkdeveloptool wl 0 /path/to/os_image.img`

!!! Warning
    The image must be Raw image, not in compressed form.

**5.** After image writing finished, reset the system

`sudo tools/rkdeveloptool rd`

**6.** Remove jumper on P13, you should have USB Serial connected to your PC.

**7.** Continue to [setup the OS through Serial Console](/helios64/install/first-start/).


## References

[Rkdeveloptool - Rockchip Open Source Document](http://opensource.rock-chips.com/wiki_Rkdeveloptool)

[Rockusb - Rockchip Open Source Document](http://opensource.rock-chips.com/wiki_Rockusb)
