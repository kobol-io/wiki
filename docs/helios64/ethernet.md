## Ethernet

The ethernet port is located at the back of helios 64 device:

![Eth Location](/helios64/img/ethernet/eth-back.jpg)

There are 2 ethernet port in the backplate of Helios64:

![Eth Description](/helios64/img/ethernet/eth-backplate-labeled.jpg)

The 1Gbps ethernet interface is supported by RTL8211F chipset which connected to RK3399 by RGMII.
Theoretically this interface support 1G bit per second transfer rate, by default configured as full duplex and support wake on LAN (WoL) featue.
In the manufacturing process, even mac address was assigned to this interface (e.g. 64:62:66:d0:00:00)

The second interface rated at 2.5Gbps, this interface use RTL8156 controller.
The 2.5 Giga bit per second interface is connected to RK3399 via [USB 3.0 Hub](/helios64/usb/#usb-on-helios64).
This interface support full duplex communication and also wake on lan (WoL).
Odd number was choosen as the mac address of this interface (e.g. 64:62:66:d0:00:01)

