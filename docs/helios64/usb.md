

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

![!USB-C OTG Cable](/helios64/img/usb/otg_cable_usb_c.jpg)

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
modprobe g_mass_storage file=/dev/sda,/dev/sdb,/dev/sdc,/dev/sdd,/dev/sde iSerialNumber=1234567890 iManufacturer="Kobol Innovations" iProduct=Helios64
```

----- *** Put Windows Explorer & Disk management screenshot here *** ----- 


***Helios64 connected to PC running Linux***

USB device visualization using [USBview](http://www.kroah.com/linux-usb/)
![!usbview Screenshot](/helios64/img/usb/linux_gadget_das_usbview.png)

USB tree using lsusb
![!lsusb tree Screenshot](/helios64/img/usb/linux_gadget_das_lsusb_tree.png)

```
$ sudo lsusb -s 2:7 -v

Bus 002 Device 007: ID 0525:a4a5 Netchip Technology, Inc. Pocketbook Pro 903
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         9
  idVendor           0x0525 Netchip Technology, Inc.
  idProduct          0xa4a5 Pocketbook Pro 903
  bcdDevice            4.04
  iManufacturer           3 Kobol Innovations
  iProduct                4 Helios64
  iSerial                 5 1234567890
  bNumConfigurations      1
OTG Descriptor:
  bLength                 3
  bDescriptorType         9
  bmAttributes         0x03
    SRP (Session Request Protocol)
    HNP (Host Negotiation Protocol)
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           47
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower              126mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk-Only
      iInterface              1 Mass Storage
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
Binary Object Store Descriptor:
  bLength                 5
  bDescriptorType        15
  wTotalLength           22
  bNumDeviceCaps          2
  USB 2.0 Extension Device Capability:
    bLength                 7
    bDescriptorType        16
    bDevCapabilityType      2
    bmAttributes   0x00000006
      Link Power Management (LPM) Supported
  SuperSpeed USB Device Capability:
    bLength                10
    bDescriptorType        16
    bDevCapabilityType      3
    bmAttributes         0x00
    wSpeedsSupported   0x000f
      Device can operate at Low Speed (1Mbps)
      Device can operate at Full Speed (12Mbps)
      Device can operate at High Speed (480Mbps)
      Device can operate at SuperSpeed (5Gbps)
    bFunctionalitySupport   1
      Lowest fully-functional device speed is Full Speed (12Mbps)
    bU1DevExitLat           1 micro seconds
    bU2DevExitLat         500 micro seconds
Device Status:     0x0000
  (Bus Powered)

```

xfce file manager (thunar)
![!Thunar Screenshot](/helios64/img/usb/linux_gadget_das_thunar_5_drive.png)

lsblk output:
```
$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdc      8:32   0 111,8G  0 disk 
└─sdc1   8:33   0 111,8G  0 part 
sdd      8:48   0 111,8G  0 disk 
└─sdd1   8:49   0 111,8G  0 part 
sde      8:64   0 111,8G  0 disk 
└─sde1   8:65   0 111,8G  0 part 
sdf      8:80   0 111,8G  0 disk 
└─sdf1   8:81   0 111,8G  0 part 
sdg      8:96   0 111,8G  0 disk 
└─sdg1   8:97   0 111,8G  0 part 

$ lsblk -S
NAME HCTL       TYPE VENDOR   MODEL             REV TRAN
sda  0:0:0:0    disk ATA      WDC WDS240G2G0B- 0000 sata
sdb  1:0:0:0    disk ATA      TOSHIBA MQ04ABF1 0J   sata
sdc  2:0:0:0    disk Linux    File-Stor Gadget 0404 usb
sdd  2:0:0:1    disk Linux    File-Stor Gadget 0404 usb
sde  2:0:0:2    disk Linux    File-Stor Gadget 0404 usb
sdf  2:0:0:3    disk Linux    File-Stor Gadget 0404 usb
sdg  2:0:0:4    disk Linux    File-Stor Gadget 0404 usb
```



#### RAID device exported as One Disk

----- ***more info soon*** -----

```
modprobe g_mass_storage file=/dev/md/md-raid6
```

----- *** Put Windows Explorer & Disk management screenshot here *** ----- 

----- *** Put lsusb & lsblk here *** ----- 


## Benchmark

----- ***more info soon*** -----


## References
[1] https://www.kernel.org/doc/html/v5.4/usb/mass-storage.html
