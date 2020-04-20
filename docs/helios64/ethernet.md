![Ethernet Location](/helios64/img/ethernet/ethernet.jpg)

Helios64 has 2x BASE-T Ethernet interfaces :

* LAN 1 : 1000BASE-T (1 Gbit/s)
* LAN 2 : 2.5GBASE-T (2.5 Gbit/s)

LAN 1 is the native Gigabit Ethernet interface from SoC RK3399. The interfaces is exposed through the Ethernet transceiver RTL8211F connected to RK3399 via RGMII.

![Ethernet 1GbE Diagram](/helios64/img/ethernet/eth_1gbe_diagram.jpg)

LAN2 is the Multigigabit (2.5Gb) Ethernet interface provided through Realtek RTL8156 controller which is an USB3.0 to LAN bridge. The controller is connected to RK3399 via [VL815 USB 3.0 Hub](/helios64/usb/#usb-on-helios64).

![Ethernet 2.5GbE Diagram](/helios64/img/ethernet/eth_2-5gbe_diagram.jpg)

## Features

Both Ethernet interfaces supports the following features :

* Transfer Rate Auto-Negotiation
* Full-duplex and Half-duplex operation
* IEEE 802.3az Energy Efficient Ethernet
* IEEE 802.1Q VLAN tagging
* Wake-on-LAN (WOL)
* Crossover Detection & Auto-Correction
* Automatic Polarity Correction

## About MAC address

Each Helios64 unit comes with a unique MAC address for each Ethernet interfaces. These MAC addresses, allocated and programmed during manufacturing process, comes from a MAC Address Block assigned to Kobol Innovations Pte. Ltd. by the IEEE Registration Authority.

The following MAC Address Block Medium (MA-M) has been allocated to us :

| 28-bit Base Value | EUI-48 Address Block |
|-------------------|----------------------|
| 64-62-66-D | 0-00-00 through F-FF-FF |
