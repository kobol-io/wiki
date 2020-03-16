## UEXT overview
the development boards so customer can choose which feature he want to use.

UEXT (Universal-Extension-Connector) is board to board connector which support 3 serial communication interface, such as I2C, SPI, RS232.
The combination of theese feature is supported by every decent microcontroller, this will enable broad choice to connect modules.
UEXT gives you freedom to choose module that you want to use.

!!! Notice
        As UEXT have RS232 and the Rx and Tx signals should be crossed we can say that UEXT on the board is with HOST; UEXT on the module is with SLAVE/DEVICE layout.


## Pinout Table
Helios64 provides UEXT on header P2 which following the UEXT standard, containing UEXT, SPI, and I2C connector.
You can find the P2 header from the connector/interface list at [hardware overview](/helios64/hardware) page.

Please find this location of UEXT header:

![P2 Location](/helios64/img/hardware/UEXT_zoom.jpg)

The pinout of the above P2 header is decribed by following figures:

![P2 Pinout](/helios64/img/hardware/UEXT_pinout.png)

Below is the detailed description of UEXT header pinout:

| PIN | Port | Remarks |
|-----|------|-------------|
| 1 | 3.3V | |
| 2 | GND | |
| 3 | TXD (UART) | |
| 4 | RXD (UART) | |
| 5 | SCL (I2C) | |
| 6 | SDA (I2C) | |
| 7 | MISO (SPI) | |
| 8 | MOSI (SPI) | |
| 9 | SCK (SPI) | |
|10 | SSEL (SPI) | |

!!! Warning
       Please note the UEXT connector at Helios64 board doesn't provide the plastic covering, so be carefull with the header polarity!
Make sure your device is correctly oriented before connecting!

## SPI and I2C

The implementation of SPI and I2C in the UEXT connector is follow similar convention in the Helios64 board. Please refer to this page:

- [SPI](/helios64/hardware/)
- [I2C](/helios64/I2C/)


## Exception

We have connected the UART bus from the RK3399 to the serial console in the USB-C, so there is no dedicated line of UART in the UEXT connector.
The UART bus in this UEXT header is the parallel ones with the serial console.
Therefore if you connect some module which might ***require dedicated serial UART line*** to the RK3399, this module ***will not function as expected***.

!!! Notes
       Please note also, that GPS modules in UEXT format also will not work due to similar reason.

## References
https://www.olimex.com/Products/Modules/UEXT/
