

## USB on RK3399
There are two types of USB controller available on RK3399. Each type has two controller so total USB controllers is 4.

### Generic EHCI USB 2.0 Controller
There are two controller of this type. This controller is Host only controller that is compatible with USB 2.0 and backward compatible with USB 1.1.
Supported speed:

- High Speed (480 Mbps)

- Full Speed (12 Mbps)

- Low Speed (1.5 Mbps)


### Synopsys DesignWare USB 3.0 Dual-Role Device Controller
There are two controller of this type. This controller support On-The-Go /Dual Role which mean it can be configured as Host and also Device.
Supported speed:

- Super Speed (5 Gbps)

- High Speed (480 Mbps)

- Full Speed (12 Mbps)

- Low Speed (1.5 Mbps)

The controller is connected to Rockchip Type-C PHY.

## USB on Helios64

![!USB Connection](/helios64/img/usb/usb_diagram.png)

One of EHCI Controller is connected to M.2 socket.

The first Synopsys DesignWare USB 3.0 Dual-Role Device Controller is connected to USB Type-C connector and configured as OTG with help of FUSB302.

The second Synopsys DesignWare USB 3.0 Dual-Role Device Controller is connected to USB Hub 3.1 Gen 1 and configured as Host only.

### Power Budget

Each of external USB port is protected by Power Distribution switch with following current limit.

| Port | Voltage | Maximum Current | Remarks |
|------------|-------|------------------|---------|
| USB 3.0 Upper Back Panel | 5V | 900 mA | |
| USB 3.0 Lower Back Panel | 5V | 900 mA | |
| USB 3.0 Front Panel | 5V | 900 mA | |
| Type-C | 5V | 1200 mA | PDO source only |


## USB Type-C Functionality on Helios64

To simplify the cabling, Helios64 is designed to have 

![!USB Mux](/helios64/img/usb/usb_mux.png)

### Serial Console

Serial Console of Helios64 is connected to FT232 USB Serial converter and the USB 2.0 signal of the FT232 is connected to USB 2.0 signals of USB Type-C Port.
Refer to ***JUMPER PAGE***


### DisplayPort Alternate Mode

Using USB Type-C to DisplayPort cable or USB Type-C to HDMI dongle, Helios64 can be connected to monitor to display Linux Desktop or other GUI application.

*** Put USB Type-C to DisplayPort cable photo here ***

*** Put USB Type-C to HDMI dongle photo here ***

!!! note
    DisplayPort Alternate Mode is NOT supported on U-Boot.


### USB Host

Using OTG cable such as,

![!USB-C OTG Cable](/helios64/img/usb/otb_cable_usb_c.jpg)

Helios64 can act as USB host and can be connected to various USB device.

### USB Device

Helios64 can be used as Direct Attached Storage (DAS) with proper configuration and kernel module. Refer to [Helios64 as Direct Attached Storage (DAS) device](#helios64-as-direct-attached-storage-das-device)

Helios64 can also used as "USB eMMC reader/writer" for OS recovery purpose. Refer to [USB OTG Port (USB Type-C)](#usb-otg-port-usb-type-c)


## USB under U-Boot

### USB Host Port

USB Host support in U-Boot is quite minimal, it only support USB storage and USB ethernet.

### USB OTG Port (USB Type-C)

USB Type C port is configured as USB device mode as USB Mass Storage connected to eMMC.
This function can be activated by pressing Recovery Button.
This is to serve as a way to (re)install OS to eMMC.


## USB under Linux

### USB Bus Mapping

| USB Controller | Bus number | Remarks |
|----------------|------------|---------|
| EHCI Host0 | 0 | |
| EHCI Host1 | 1 | |
| DWC3 Typec0 USB 3.0 | 2 |  |
| DWC3 Typec0 USB 2.0 | 3 |  |
| DWC3 Typec1 USB 3.0 | 4 |  |
| DWC3 Typec1 USB 2.0 | 5 |  |

-----  ***TBC***  ------

### Helios64 as Direct Attached Storage (DAS) device

Helios64 can be used as Direct Attached Storage (DAS) device with help of Linux USB Gadget kernel module.

The kernel moodule only export the underlying block device NOT the filesystem layer. Therefore if the block device is formatted with filesystem unique to Linux,
the exported disk may not readable by computer that has Helios64 connected to.

For example, the block device is formatted with EXT4 filesystem and Helios64 connected to Windows PC as DAS,
the Windows PC will not be able to read the disk content unless 3rd party software/driver installed.


!!! warning
    Do NOT access Helios64 simultanouesly as DAS and NAS, as the filesystem is not managed by system and can lead to data corruption.


#### Individual Disk Exported as Separate Disk

----- ***more info soon*** -----

```
modprobe g_mass_storage file=/dev/sda,/dev/sdb,/dev/sdc,/dev/sdd,/dev/sde
```

----- *** Put Windows Explorer & Disk management screenshot here *** ----- 

----- *** Put lsusb & lsblk here *** ----- 


#### RAID device exported as One Disk

----- ***more info soon*** -----

```
modprobe g_mass_storage file=/dev/md/md-raid6
```

----- *** Put Windows Explorer & Disk management screenshot here *** ----- 

----- *** Put lsusb & lsblk here *** ----- 



