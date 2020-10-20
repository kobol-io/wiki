Maskrom is special internal firmware of RK3399 that run **Rockusb** driver automatically when there is no 
bootable firmware found on on-board storage such as SPI flash, eMMC or microSD card.

On Helios64, there are two ways to enter the maskrom mode:

- Disable SPI flash and eMMC according to [Boot Mode Jumper](/helios64/jumper/#boot-mode-p10-p11) and remove microSD card.

- Using [Recovery Button](/helios64/button/#recovery-button)

Rockusb is a vendor specific USB class from Rockchip to download firmware. 
This USB device has Vendor ID *0x2207* and Product ID *0x330c*.

!!! Info
    U-Boot has *rockusb* command, but it is not compatible with the Rockchip utilities

## Prerequisites

### RK3399 loader

  In maskrom mode, SoC initiliazed without DRAM and storage support therefore it need *loader* to initialized DRAM and prepare the flashing environment.
  
  Download the loader from [here](/helios64/files/maskrom/rk3399_loader_v1.24_RevNocRL.126.bin)

### Windows

#### Rockusb driver

Download and extract *DriverAssistant.zip* from [Rockchip GitHub](https://github.com/rockchip-linux/tools/tree/rk3399/windows).

Run **DriverInstall.exe** under the extracted folder and press **Install Driver**.

!!! Info
    At this time of writing, the filename is *DriverAssitant_v4.6.zip* and the extracted folder is *DriverAssitant_v4.6*

#### AndroidTools

Download and extract *AndroidTool_Release.zip* from [Rockchip GitHub](https://github.com/rockchip-linux/tools/tree/rk3399/windows).

!!! Info
    At this time of writing, the filename is *AndroidTool_Release_v2.52.zip*.

### Linux

Download prebuilt rkdevelop from [Rockchip GitHub](https://github.com/rockchip-linux/rkbin/archive/master.zip). 
Extract the downloaded *rkbin-master.zip* file.

!!! Note
    You could also compile it from source by following instructions at [Rockchip Wiki](http://opensource.rock-chips.com/wiki_Rkdeveloptool).

## Using Maskrom

**1)** Make sure the system is powered off.

**2)** Put jumper cap to P13 to enable it.

![!Jumper P13](/helios64/img/maskrom/jumper_p13_enabled.jpg)

**3)** Plug in USB type-C cable to Helios64 and the other side to PC.

**4 a)** Disable SPI flash and eMMC according to [Boot Mode Jumper](/helios64/jumper/#boot-mode-p10-p11) and remove microSD card. Power on the system.

 or

**4 b)** Press and hold Recovery button. Power on the system and release recovery button after System Status LED blink twice. 

### Under Windows

**1.** Open Device Manager and verify whether rockusb device is recognized.

![rockusb on Device Manager](/helios64/img/maskrom/rockusb_device.png)

**2.** Run **AndroidTool.exe** and check whether there is **Found One MASKROM Device**.

![!AndroidTool Main Window](/helios64/img/maskrom/androidtools_00_main.png)

**3.** Press button to load and select following files,

- Loader = rk3399_loader_v1.24_RevNocRL.126.bin

- Image = OS image to write

!!! Warning
    The image must be Raw image, not in compressed form.

![!AndroidTool Files loaded](/helios64/img/maskrom/androidtools_01_ready_to_download.png)

**4.** Checklist both row and press **Run** button. Observer the log textbox.

![!AndroidTool Writing Images](/helios64/img/maskrom/androidtools_02_download_in_progress.png)

**5.** The log textbox will show **Download image OK** when finished and system will automatically reboot.

![!AndroidTool Writing Images](/helios64/img/maskrom/androidtools_03_done.png)

**6.** Remove jumper on P13, you should have USB Serial connected to your PC.

**7.** Continue to setup the OS through Serial Console.


## References

[Rkdeveloptool - Rockchip Open Source Document](http://opensource.rock-chips.com/wiki_Rkdeveloptool)

[Rockusb - Rockchip Open Source Document](http://opensource.rock-chips.com/wiki_Rockusb)


