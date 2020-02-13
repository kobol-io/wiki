## Block Diagram

### Helios64 Carrier Board
![!Block Diagram](/helios64/img/hardware/helios64-block-diagram.png)

### RK3399 System-On-Chip
![!Block Diagram](/helios64/img/hardware/RK3399_block_diagram.png)

This block diagram is cited from the RK3399 website documentation. [1](http://opensource.rock-chips.com/wiki_File:RK3399_Block_Diagram.png)

## Connector / Interface List



![!Board Legend](/helios64/img/hardware/helios64_board_labeled.jpg)

Name |Peripheral Type|Connector Type|Details
-----|---------------|--------------|-------
P10|eMMC|2x1 Pin Male Header|Disable eMMC boot
P11|SPI Flash|2x1 Pin Male Header|Disable SPI Flash
P13|HS Select|2x1 Pin Male Header|USB-C HS Select (Close = Type C HS, Open = Console)
J1|USB3|USB 3.0| USB 3.0 Port Header 
J3|SATA|SATA 3.0|Port 0 (SATA1)
J4|SATA|SATA 3.0|Port 1 (SATA2)
J5|SATA|SATA 3.0|Port 2 (SATA3)
J6|SATA|SATA 3.0|Port 3 (SATA4)
J7|HDD Power|8 Pin ATX 12V|Rated for 5x HDD
J8|SATA|SATA 3.0|Port 4 (SATA5)
J9|Battery Power|6 Pin ATX 12V|Battery Backup
J10|ATX Power Supply|4 Pin ATX 12V|4 Pin ATX Power Connector
J11|LAN1|RJ45|Gigabit Ethernet
J12|LAN2|RJ45|2.5 Gigabit Ethernet
J13|USB 3.0|Dual Port USB3.0|Type A
J14|microSD|Push-Push card connector|Support SDHC and SDXC
J15|Serial port|Micro-USB Connector|Via onboard FTDI USB-to-UART0 bridge
J16|DC connector|Kycon 4-Pin Mini-DIN|DC input 12V / 8A
FAN1|Fan|4x1 Pin Male Header|PWM and RPM support
FAN2|Fan|4x1 Pin Male Header|PWM and RPM support
P1|I2C|4x1 Pin Male Header|I2C Bus 1
P2|UEXT|2x5 Pin Male Header|Universal EXTension Support [2]
P3|Front Panel|12x1 Pin Male Header|PWM and RPM support
P4|Buzzer|2x1 Pin Header|Buzzer Speaker Support 
P5|GPIO|7x2 Pin Male Header|GPIO configurable as input or output<br>Via IO Expander on I2C Bus 0
SW1|Power|Push Button|Power Button
SW2|Boot Mode|Push Button|Boot mode selector :<br> SPI,MMC,UART,SATA
SW3|Reset|Push Button|Reset Button

## Boot Modes

Helios64 supports at least **3 (TBD)** boot modes that can be chosen by using the jumper configuration.

Please see above figure for the connector/interface list. Following jumper are available in the Helios64 board to configure the boot modes:
- P11 Jumper to disable SPI Flash, when this jumper is shorted/close it means disable the SPI Flash (Open = enable)
- Disable eMMC, Close = disable, Open = enable eMMC (P10)
- USB Mux, HS select, Close = type C HS, Open = Console (P13)
	by default your USB C cabel will will connected to the serial Console of The Helios64 board. By closing this connection the USB-C connection will become the HS mode, the eMMC will be detected as the USB Mass storage in your PC, and you can directly flash the Armbian image to it.


![Dipswitch modes](/helios4/img/hardware/dipswitch_modes.jpg)

All the ready-to-use images we provide are for the **SD Card** boot mode.

Please refer to [U-boot](/helios4/uboot) section to know how to use the other modes.

## LED indicators

LED Name|Color|Description
---|---|---
LED1|green|System heartbeat
LED2|red|Error status
LED3|green|SATA1 activity
LED4|green|SATA2 activity
LED5|green|SATA3 activity
LED6|green|SATA4 activity
LED7|green|USB activity
LED8|green|Power indicator

Helios4 board was designed to either use the on-board LEDs or use an expansion panel (not-available). To use the on-board LEDs insure to switch to ON the dipswitch SW2.

![Dipswitch LED](/helios4/img/hardware/dipswitch_led_on.jpg)

## Reset Button

Helios4 board provides a RESET push button (U16) to hard reset the SoC (System-On-Chip).

![Reset Button](/helios4/img/hardware/reset_button.jpg)

!!! Important
    This button only resets the SoC and not the overall board. For instance it won't reset the HDD.

## I2C Interface

Helios4 board exposes on header J9 the SoC I2C Bus 1. Below is the header pin-out, the little arrow on the PCB indicates the ground pin.

![I2C Pinout](/helios4/img/hardware/i2c_pinout.png)

## Power Consumption

**Board only**

* Idle  : 3.6 Watts
* Active : 5.6 Watts

**Full Kit (with 4x HDDs)**

| State               | AC calculated<br>power consumption | DC measured<br>power consumption | Remarks             |
|---------------------|----------------------|----------------------|---------------------|
|  Idle               | 19.3 W               | 16.8 W               |                     |
|  HDD Read Access    | 27.4 W               | 22.8 W               |                     |
|  HDD Write Access   | 30.3 W               | 25.2 W               |                     |
|  Standby            | 8.0 W                | 6.7 W                | HDD in Standby mode |
|  Suspend-to-Ram     | 7.2 W                | 6.0 W                | HDD in Standby mode |

!!! note
    Measures were done using a Current Clamp Meter on the Helios4 12V DC input. AC Power consumption is calculated based on a AC/DC conversion efficiency of 85%.

    * Meter tool : Extech 380942 - 30A True RMS AC/DC Mini Clamp
    * AC/DC Adapter : yczx1268 (efficiency : 85%)
    * AC Input Voltage: 220V
    * HDD: 4x WD Red 2TB (WD20EFRX) configured as RAID10
    * Network : Connected at 1000Mb/s
    * OS: ARMBIAN 5.73 stable Debian GNU/Linux 9 (stretch) 4.14.98-mvebu   


## HDD Recommendation List

We recommend HDD which are designed for NAS (Network Attached Storage). Those NAS HDD are specially conceived for reliable 24/7 operation and offers lower power consumption and dissipation, less vibration and noise, and finally better warranty. We recommend the following models :

**Western Digital** : WD Red NAS (1, 2, 3, 4, 6, 8 and 10TB)

- WD10EFRX
- WD20EFRX
- WD30EFRX
- WD40EFRX
- WD60EFRX
- WD80EFZX
- WD100EFAX

**Seagate** : IronWolf NAS (1, 2, 3, 4, 6, 8 and 10TB)

- ST1000VN002
- ST2000VN004
- ST3000VN007
- ST4000VN008
- ST6000VN0041
- ST8000VN0022
- ST10000VN0004

**HGST** : Deskstar NAS (4, 6 and 8TB)

- 0S04005
- 0S04007
- 0S04012

!!! note
    We recommend to order from different shop to avoid having all the drives from the same factory batch. For instance, you should order 2x HDDs from one shop, then the 2 others from another shop.

## HDD / SSD Compability List

Please refer to [Synology DS416j Compatibility List](https://www.synology.com/en-global/compatibility?search_by=products&model=DS416j&category=hdds&p=1) that covers a large number of tested drives. The DS416j used the same SoC family than Helios4.


## References
1. http://opensource.rock-chips.com/wiki_File:RK3399_Block_Diagram.png
2. https://en.wikipedia.org/wiki/UEXT
