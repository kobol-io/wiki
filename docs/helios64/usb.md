![USB Location](/helios64/img/usb/usb_ports.jpg)

## USB Controller Types

There are 3 types of USB controller available on RK3399 SoC. Each type has 2 controllers, so in total there are 6 USB controllers. Below a description of each controller type.

### Generic OHCI USB 1.1 Controller
This controller is Host only controller that is compatible with USB 1.1.

Supported speeds:

- Full Speed (12 Mbps)
- Low Speed (1.5 Mbps)

### Generic EHCI USB 2.0 Controller
This controller is Host only controller that is compatible with USB 2.0. The controller shared port with
*Generic OHCI USB 1.1 Controller* therefore any USB 1.1 device connected to the port, will be automatically routed to *Generic OHCI USB 1.1 Controller*.

Supported speed:

- High Speed (480 Mbps)

### Synopsys DesignWare USB 3.0 Dual-Role Device Controller
This controller support On-The-Go / Dual Role which means it can be configured as Host or as Device.

Supported speeds:

- Super Speed (5 Gbps)
- High Speed (480 Mbps)
- Full Speed (12 Mbps)
- Low Speed (1.5 Mbps)

This controller is connected to RK3399 Type-C PHY.

## USB on Helios64

![USB Connection](/helios64/img/usb/usb_diagram.png)

* The first USB 3.0 Dual-Role Device Controller is connected to USB Type-C connector (J15) and configured as OTG with help of [FUSB302](https://www.onsemi.com/products/interfaces/usb-type-c/fusb302).
* The second USB 3.0 Dual-Role Device Controller is connected to USB Hub 3.1 Gen 1 and configured as Host only.
* One of EHCI Controller (and OHCI Controller) is connected to M.2 socket.

### Power Budget

Each external USB port is protected by a Power Distribution switch with following current limit.

| Port | Voltage | Maximum Current | Remarks |
|------------|-------|------------------|---------|
| USB 3.0 Upper Back Panel | 5V | 900 mA | |
| USB 3.0 Lower Back Panel | 5V | 900 mA | |
| USB 3.0 Front Panel | 5V | 900 mA | |
| Type-C | 5V | 1200 mA | PDO source only |


## Type-C Functionality on Helios64

To minimize number of interfaces and cables, Helios64 combined 4 functions into the USB Type-C interface :

* Serial Console
* Display Port
* Host Mode
* Device Mode (aka DAS mode)

![USB Mux](/helios64/img/usb/usb_mux.png)

Helios64 uses an High Speed multiplexer on USB 2.0 signal. By default the USB 2.0 signal is routed to USB Serial Console.
The multiplexer can be override using [jumper P13](/helios64/jumper/#usb-consolerecovery-mode-p13) or by software via GPIO.

### Serial Console

Serial Console (UART2 Debug) of RK3399 SoC is connected to FT232 USB Serial converter and the USB 2.0 signal of the FT232 is connected to USB 2.0 signals of USB Type-C Port.

In case you are using the USB-C for one of the others functionalities but you still need to access SoC serial console for debug purpose, UART2 Debug is also exposed on P14 header.

![P14 Pinout](/helios64/img/usb/p14_pinout.jpg)

### Display Port

Using USB Type-C to DisplayPort cable, Helios64 can be connected to monitor to display Linux Desktop or others GUI applications.

![Type-c to DisplayPort](/helios64/img/usb/typec_dp.jpg)

Using USB Type-C to HDMI cable/dongle, Helios64 can be connected to a TV and used as a media center.

![Type-c to HDMI female](/helios64/img/usb/typec_hdmi_dongle.jpg)

*USB Type-C to HDMI dongle*

![Type-c to HDMI male](/helios64/img/usb/typec_hdmi.jpg)

*USB Type-C to HDMI cable*

!!! note
    - DisplayPort Alternate Mode is NOT supported on U-Boot.
    - USB Type-C to HDMI cable might not work if it used DisplayPort dual mode (DP++).

### Host Mode

Using OTG cable (Type-C to Type A female) such as,

![Type-C to Type-A female](/helios64/img/usb/typec_typea_female.jpg)

Helios64 can act as USB host and can be connected to various USB devices.

### Device Mode

Using Type-C to Type A male cable such as,

![Type-C to Type-A male](/helios64/img/usb/typec_typea_male.jpg)

Helios64 can be used as Direct Attached Storage (DAS) with the required software configuration. It can also be used as "USB eMMC reader/writer" during system recovery mode.


## USB under U-Boot

### USB Host Port

USB Host support in U-Boot is quite minimal, it only supports USB storage.

### USB OTG Port (USB Type-C)

USB Type C port is configured as USB Mass Storage connected to eMMC. This function, called UMS mode, can be activated by pressing [Recovery Button](/helios64/button/#ums-mode). This is to serve as a way to (re)install OS to eMMC.


## USB under Linux

!!! Info
    Currently only applicable to Linux Kernel 4.4. Mainline kernel support is still under development.

### Helios64 as Direct Attached Storage (DAS) device

Helios64 can be used as Direct Attached Storage (DAS) device with help of Linux USB Gadget kernel module.

The kernel module only exports the underlying block device NOT the filesystem layer. Therefore if the block device is formatted with filesystem unique to Linux, the exported disk may not be readable by the computer connected to Helios64 connected.

For example, if the block device is formatted with EXT4 filesystem and Helios64 connected to Windows PC as DAS, the Windows PC will not be able to read the disk content unless 3rd party software/driver installed.


!!! warning
    Do NOT export block device(s) that you are also accessing via network (unless in read-only mode), as the filesystem of the exported block device cannot be managed concurrently and can lead to data corruption. Refer to kernel Mass Storage Gadget (MSG) [page](https://www.kernel.org/doc/html/latest/usb/mass-storage.html) to understand better the limitation.

#### Export Individual Disk

To export all SATA disks that have been identified as /dev/sda ... /dev/sde, run the following command on Helios64:

```
sudo modprobe g_mass_storage file=/dev/sda,/dev/sdb,/dev/sdc,/dev/sdd,/dev/sde iSerialNumber=1234567890 iManufacturer="Kobol Innovations" iProduct=Helios64
```

The following screenshots show Helios64 connected with 5x 120GB SATA disks.

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
sda  0:0:0:0    disk ATA      WDC WDS240G2G0B  0000 sata
sdb  1:0:0:0    disk ATA      TOSHIBA MQ04     0J   sata
sdc  2:0:0:0    disk Linux    File-Stor Gadget 0404 usb
sdd  2:0:0:1    disk Linux    File-Stor Gadget 0404 usb
sde  2:0:0:2    disk Linux    File-Stor Gadget 0404 usb
sdf  2:0:0:3    disk Linux    File-Stor Gadget 0404 usb
sdg  2:0:0:4    disk Linux    File-Stor Gadget 0404 usb
```

#### Export RAID Array

Assuming the RAID array is already created and identified as /dev/md0, run the following command on Helios64 to export the RAID block device as USB Mass Storage

```
sudo modprobe g_mass_storage file=/dev/md0 iManufacturer="Kobol Innovations" iProduct="Helios64" iSerialNumber="1234567890"
```

The following screenshots show Helios64 connected with 5x 120GB SATA disks and configured as RAID 6 so total space of the block device is ~360GB (3x 120GB). The block device is then formatted with NTFS.

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
sda  0:0:0:0    disk ATA      WDC WDS240G2G0B  0000 sata
sdb  1:0:0:0    disk ATA      TOSHIBA MQ04     0J   sata
sdc  2:0:0:0    disk Linux    File-Stor Gadget 0404 usb
```
