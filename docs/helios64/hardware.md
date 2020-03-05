## Block Diagram

### Helios64 Board
![!Block Diagram](/helios64/img/hardware/helios64-block-diagram.png)

### RK3399 System-On-Chip
![!Block Diagram](/helios64/img/hardware/RK3399_block_diagram.png)

This block diagram is cited from the RK3399 website documentation. [1](http://opensource.rock-chips.com/wiki_File:RK3399_Block_Diagram.png)

## Connector / Interface List


![!Board Legend](/helios64/img/hardware/helios64_board_labeled.jpg)

Name |Peripheral Type|Connector Type|Details
-----|---------------|--------------|-------
P8|SATA Cont. Mem. Flash Enable Jumper|2x1 Pin Header|Sata Controller Flash Memory Enable 
P9|eFuse Dis. Jumper|Not Populated|**TBD** eFuse Power Supply
P10|eMMC Dis. Jumper|2x1 Pin Male Header|Disable eMMC boot
P11|SPI Flash Dis. Jumper|2x1 Pin Male Header|Disable SPI Flash
P13|HS Select Jumper|2x1 Pin Male Header|USB-C HS Select (Close = Type C HS, Open = Console)
P14|ATX Priority Jumper|2x1 Pin Male Header|ATX Supply Priority
P15|ACDC Priority Jumper|2x1 Pin Male Header|ACDC(AC Adapter) Supply Priority
USB 3.0 |USB3 Host|USB 3.0 Host| USB 3.0 Port Header 
SATA1|SATA|SATA 3.0|Port 0 (SATA1)
SATA2|SATA|SATA 3.0|Port 1 (SATA2)
SATA3|SATA|SATA 3.0|Port 2 (SATA3)
SATA4|SATA|SATA 3.0|Port 3 (SATA4)
SATA5|SATA|SATA 3.0|Port 4 (SATA5)
HDD_PWR|HDD Power Conn.|8 Pin ATX 12V|Rated for 5x HDD
BATT|Battery Power Conn.|6 Pin ATX 12V|Battery Backup
ATX_4P|ATX Power Supply Conn.|4 Pin ATX 12V|4 Pin ATX Power Connector
1Gbps ETH|LAN1|RJ45|Gigabit Ethernet
2.5Gbps ETH|LAN2|RJ45|2.5 Gigabit Ethernet|USB 3.0 Host|Dual Port USB3.0|Type A
MICRO SD|microSD|Push-Push card connector|Support SDHC and SDXC
USB-C|USB Type-C Dual Role|USB Type-C Connector|Via onboard FTDI USB-to-UART0 bridge
PWR CON|DC Connector|Kycon 4-Pin Mini-DIN|DC input 12V / 8A
FAN1|Fan Connector|4x1 Pin Male Header|PWM and RPM support
FAN2|Fan Connector|4x1 Pin Male Header|PWM and RPM support
P1|I2C Header|4x1 Pin Male Header|I2C Bus 1
P2|UEXT Header|2x5 Pin Male Header|Universal EXTension Support [2]
P3|Front Panel Header|12x1 Pin Male Header|PWM and RPM support
P4|Buzzer Header|2x1 Pin Header|Buzzer Speaker Support 
P5|GPIO Pin Header|7x2 Pin Male Header|GPIO configurable as input or output<br>Via IO Expander on I2C Bus 0
PWR BTN|Power Button|Push Button|Power Button
RECOVERY|Recovery Button|Push Button|Boot mode selector :<br> SPI,MMC,UART,SATA
RST BTN|Reset Button|Push Button|Reset Button

## Boot Modes

Helios64 supports at least **3 (TBD)** boot modes that can be chosen by using the jumper configuration.

The default Boot device order for Helios64 is the SPI Flash Memory, eMMC, then micro-SD Card.
The SoC will access this order sequentially to find the bootloader in all possible storage medium.
To change the boot order if the bootloader are present in all possible volatile storage, we can use the combination of P10 and P11 jumpers.
(Please see above figure for the connector/interface list.)
Following jumper are available in the Helios64 board to configure the boot modes:

- P11 jumper can be used disable SPI Flash, when this jumper is shorted/close it means disable boot from the SPI Flash, and the board will search the next boot device (which is eMMC). 
- P10 jumper is available to disable eMMC boot, when this jumper is closed Helios64 wil skip looking for bootloader from the eMMC and will continue with the micro-SD card,

So you can select to search for bootloader starting from the SPI Flash Storage, eMMC, untill micro-SD card.
Following table may simplified boot ordering by jumper config by assuming the bootloaders are present in every storage device:

P11 State|P10 State|Boot Order|Notes
-----|---------------|--------------|-------
0|0|SPI Flash|-
1|0|eMMC|-
1|1|micro-SD Card|-

!!! note
	Please note, in case of bootloader is not present in the storage devices. The SoC will search to the next possible boot device.

## Jumpers 

- P13 jumper is the HS select, when this jumper closed the High Speed USB (USB 2.0) connection to the SoC will be establised, while the serial console is disconnected, so you can use flashing technology such as rockusb and maskrom in the USB type-C port.

[comment]: <> (its also called as HS select, when this jumper is closed the micro USB-C connector become type-C HS (open = console), your USB-C cable will connected to the serial console of the Helios64 board by default. By closing this connection the USB-C connection will become the HS mode, the eMMC will be detected as the USB Mass storage in your PC, in this configuration can directly flash the Armbian image to it.)


![Dipswitch modes](/helios64/img/hardware/p11-13-jumper.png)

All the ready-to-use images we provide are for the **SD Card** boot mode.

Please refer to [U-boot](/helios4/uboot) section to know how to use the other modes.

## Reset Button

Helios64 board provides a RESET push button (RST BTN) to hard reset the board.

## I2C Interface

Helios64 board exposes the SoC I2C Bus 1, on header **P1**. Below is the header pin-out.

![I2C Pinout](/helios64/img/hardware/i2c_pinout.png)

## Power Consumption

**Board only**

* Idle  : X.X Watts
* Active : X.X Watts

**Full Kit (with 5x HDDs)**

| State               | AC calculated<br>power consumption | DC measured<br>power consumption | Remarks             |
|---------------------|----------------------|----------------------|---------------------|
|  Idle               | X.X W               | X.X W               |                     |
|  HDD Read Access    | X.X W               | X.X W               |                     |
|  HDD Write Access   | X.X W               | X.X W               |                     |
|  Standby            | X.X W               | X.X W                | HDD in Standby mode |
|  Suspend-to-Ram     | X.X W               | X.X W                | HDD in Standby mode |

!!! note
    Measures were done using a Current Clamp Meter on the Helios64 12V DC input. AC Power consumption is calculated based on a AC/DC conversion efficiency of 85%.

    * Meter tool : Extech 380942 - 30A True RMS AC/DC Mini Clamp
    * AC/DC Adapter :  (efficiency : YY%)
    * AC Input Voltage: 220V
    * HDD: 5x YYY XX TB (HDDCODEXX) configured as RAIDXX
    * Network : Connected at 1000Mb/s
    * OS: ARMBIAN Z.Z stable Debian GNU/Linux 10 (buster) 5.4.xx-yyy   


## References
1. http://opensource.rock-chips.com/wiki_File:RK3399_Block_Diagram.png
2. https://en.wikipedia.org/wiki/UEXT
