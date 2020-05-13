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
