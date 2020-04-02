
!!! notice
    ***preliminary info***

There are three types of USB controller available on RK3399. Each type has two controller so total USB controllers is 6.

## Generic OHCI USB 1.1 Controller
There are two controller of this type. This controller is Host only controller that is compatible with USB 1.1.
Supported speed:

- Full Speed (12 Mbps)

- Low Speed (1.5 Mbps)

## Generic EHCI USB 2.0 Controller
There are two controller of this type. This controller is Host only controller that is compatible with USB 2.0. The controller shared port with
[Generic OHCI USB 1.1 Controller](#generic-ohci-usb-11-controller) therefore any USB 1.1 device connected to the port, will be automatically
routed to [Generic OHCI USB 1.1 Controller](#generic-ohci-usb-11-controller).
Supported speed:

- High Speed (480 Mbps)


## Synopsys DesignWare USB 3.0 Dual-Role Device Controller
There are two controller of this type. This controller support On-The-Go /Dual Role which mean it can be configured as Host and also Device.
Supported speed:

- Super Speed (5 Gbps)

- High Speed (480 Mbps)

- Full Speed (12 Mbps)

- Low Speed (1.5 Mbps)

The controller is connected to Rockchip Type-C PHY.

## USB on Helios64

![!USB Connection](/helios64/img/usb/usb_diagram.png)

One of EHCI Controller (and OHCI Controller) is connected to M.2 socket.

The first USB 3.0 Dual-Role Device Controller is connected to USB Type-C connector and configured as OTG with help of [FUSB302](https://www.onsemi.com/products/interfaces/usb-type-c/fusb302).

The second USB 3.0 Dual-Role Device Controller is connected to USB Hub 3.1 Gen 1 and configured as Host only.

### Power Budget

Each of external USB port is protected by Power Distribution switch with following current limit.

| Port | Voltage | Maximum Current | Remarks |
|------------|-------|------------------|---------|
| USB 3.0 Upper Back Panel | 5V | 900 mA | |
| USB 3.0 Lower Back Panel | 5V | 900 mA | |
| USB 3.0 Front Panel | 5V | 900 mA | |
| Type-C | 5V | 1200 mA | PDO source only |


## USB Type-C Functionality on Helios64

To simplify the cabling, Helios64 is designed to maximize USB Type-C usage.

Helios64 employ High Speed multiplexer on USB 2.0 signal, by default the USB 2.0 signal is routed to USB Serial console.
The multiplexer can be override using [jumper P13](/helios64/jumper/#hs-select-p13).

![!USB Mux](/helios64/img/usb/usb_mux.png)

When Helios64 connected to PC using USB cable, there will be 2 device connected. FTDI FT232 USB Serial on USB 2.0 and Helios64 or
Unknown Device (if USB gadget is not configured yet, see below) on USB 3.0.

On Windows PC using [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html) to visualize the USB tree,

![!USB Tree View dual](/helios64/img/usb/dual_usb_device_windows.png)

In this case, Helios64 is connected to a USB 3.1 Gen 1 Hub port 1.

USB Serial Converter (FTDI FT232 USB Serial) connected under port 1 of the USB 2.0 side of the Hub and
RK3399 USB 3.0 (configured as USB Mass Storage Device) connected under port 1 of the USB 3.0 side of the Hub.

On Linux PC using [USBview](http://www.kroah.com/linux-usb/) to visualize the USB tree,

![!USBview dual](/helios64/img/usb/dual_usb_device_linux.png)

In this case, Helios64 is connected to a USB 3.1 Gen 1 Hub port 1.

FTDI FT232 USB Serial connected under port 1 of the USB 2.0 side of the Hub and
RK3399 USB 3.0 (configured as USB Mass Storage Device) connected under port 1 of the USB 3.0 side of the Hub.


!!! info
	Every USB hub connected to USB 3.0 port or higher will create a sibling device, USB Hub 2.0, from host point of view.

	USB 2.0 device connected port 1 of the USB 3.0 Hub, it will appear on USB 2.0 Hub port 1.
	If USB 3.0 Device connected to same physical port	it will appear on USB  3.0 Hub port 1.

### Serial Console

Serial Console of Helios64 is connected to FT232 USB Serial converter and the USB 2.0 signal of the FT232 is connected to USB 2.0 signals of USB Type-C Port.


### DisplayPort Alternate Mode

Using USB Type-C to DisplayPort cable or USB Type-C to HDMI dongle, Helios64 can be connected to monitor to display Linux Desktop or other GUI application.

![!type-c dp cable](/helios64/img/usb/typec_dp_cable.jpg)

<center>*USB Type-C to DisplayPort cable*</center>

![!type-c hdmi dongle](/helios64/img/usb/typec_hdmi_usb_dongle.jpg)

<center>*USB Type-C to USB 3.0, HDMI and USB Type-C dongle*</center>


!!! note
    - DisplayPort Alternate Mode is NOT supported on U-Boot.

    - USB Type-C to HDMI cable might not work if it employ HDMI Alternate Mode


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

### Helios64 as Direct Attached Storage (DAS) device

Helios64 can be used as Direct Attached Storage (DAS) device with help of Linux USB Gadget kernel module.

The kernel moodule only export the underlying block device NOT the filesystem layer. Therefore if the block device is formatted with filesystem unique to Linux,
the exported disk may not readable by computer that has Helios64 connected to.

For example, the block device is formatted with EXT4 filesystem and Helios64 connected to Windows PC as DAS,
the Windows PC will not be able to read the disk content unless 3rd party software/driver installed.


!!! warning
    Do NOT access Helios64 simultanouesly as DAS and NAS, as the filesystem is not managed by system and can lead to data corruption.


#### Individual Disk Exported as Separate Disk

To export all SATA disks that has been identified as /dev/sda ... /dev/sde, run the following command on Helios64.

```
sudo modprobe g_mass_storage file=/dev/sda,/dev/sdb,/dev/sdc,/dev/sdd,/dev/sde iSerialNumber=1234567890 iManufacturer="Kobol Innovations" iProduct=Helios64
```

The following screenshot, Helios64 connected with 5x 120GB SATA drive.

***Helios64 connected to PC running Windows***

USB device visualization using USB Device Tree Viewer
![!usbtreeview Screenshot](/helios64/img/usb/linux_gadget_das_windows_usbtreeview.png)

Helios64 in Device Manager
![!device manager Screenshot](/helios64/img/usb/linux_gadget_das_windows_device_manager.png)

Disks detected under Disk Management
![!disk mgmt Screenshot](/helios64/img/usb/linux_gadget_das_windows_diskmgmt.png)

***Helios64 connected to PC running Linux***

USB device visualization using USBview
![!usbview Screenshot](/helios64/img/usb/linux_gadget_das_usbview.png)

USB tree using lsusb
![!lsusb tree Screenshot](/helios64/img/usb/linux_gadget_das_lsusb_tree.png)

```
$ sudo lsusb -s 2:6 -v

Bus 002 Device 006: ID 0525:a4a5 Netchip Technology, Inc. Pocketbook Pro 903
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

Assuming the RAID already created and identified as /dev/md/md-raid6, run the following command on Helios64 to export the RAID block device as USB Mass Storage

```
sudo modprobe g_mass_storage file=/dev/md/md-raid6 iManufacturer="Kobol Innovations" iProduct="Helios64" iSerialNumber="1234567890"
```

The following screenshot, Helios64 connected with 5x 120GB SATA drive and configured as RAID 6 so total space of the block device is ~360GB (3x 120GB). The block device then formatted with NTFS.

***Helios64 connected to PC running Windows***

USB device visualization using USB Device Tree Viewer
![!usbtreeview Screenshot](/helios64/img/usb/linux_gadget_das_windows_usbtreeview_raid.png)

Helios64 in Device Manager
![!device manager Screenshot](/helios64/img/usb/linux_gadget_das_windows_device_manager_raid.png)

Disks detected under Disk Management
![!disk mgmt Screenshot](/helios64/img/usb/linux_gadget_das_windows_diskmgmt_raid.png)

!!! note
	Since the block device is formatted with NTFS, Windows can recognize it and assign drive letter E:

***Helios64 connected to PC running Linux***

USB device visualization using USBview
![!usbview Screenshot](/helios64/img/usb/linux_gadget_das_usbview_raid.png)

USB tree using lsusb
![!lsusb tree Screenshot](/helios64/img/usb/linux_gadget_das_lsusb_tree_raid.png)

```
Bus 002 Device 006: ID 0525:a4a5 Netchip Technology, Inc. Pocketbook Pro 903
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
![!Thunar Screenshot](/helios64/img/usb/linux_gadget_das_thunar_raid.png)

lsblk output
```
$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdc      8:32   0 335,2G  0 disk
└─sdc1   8:33   0 335,2G  0 part

$ lsblk -S
NAME HCTL       TYPE VENDOR   MODEL             REV TRAN
sda  0:0:0:0    disk ATA      WDC WDS240G2G0B- 0000 sata
sdb  1:0:0:0    disk ATA      TOSHIBA MQ04ABF1 0J   sata
sdc  2:0:0:0    disk Linux    File-Stor Gadget 0404 usb
```

## Benchmark

Simple test to measure Helios64 throughput when being used as DAS.
Helios64 configured as DAS with various disks configuration and then connected to a PC running Ubuntu 18.04.

For raw device access, following command is used:

`sudo dd if=/dev/sdc of=/dev/null bs=10M iflag=direct status=progress`

For access on top of EXT4 filesystem, following command is used:

`dd if=/media/kobol/67d5fe3b-2d54-4770-9317-e30f1fd7c2e9/dd_test_data.dat of=/dev/null bs=10M iflag=direct status=progress`

*dd_test_data.dat* file size is 20GB.

### Result

Read transfer rate in MB/s

| Configuration | Raw Device | EXT4 FS |
|---------------|------------|---------|
| 1 SATA | 316 | 313 |
| 5 Disks as RAID6 | 318 | 322 |
| 4 Disks as RAID10 | 321 | 311 |

## References
[1] https://www.kernel.org/doc/html/v5.4/usb/mass-storage.html
