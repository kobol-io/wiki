!!! info
    Wiki edition in progress

## Block Diagram

![Block Diagram](/img/hardware/block_diagram.jpg)

## Connector / Interface List

![Board Legend](/img/hardware/board_legend.jpg)

Name |Peripheral Type|Connector Type|Details
-----|---------------|--------------|-------
CON2|UART / Console port|Micro-USB Connector|Via on-board USB to UART Converter
J9|I2C|4x1 Pin Male Header|I2C Channel 1
J10|Fan|4x1 Pin Male Header|PWM and RPM support
J12|GPIO|7x2 Pin Male Header|GPIO configurable as input or output<br>Via IO Expander on I2C Channel 0
J14|HDD Power|Molex 4-Pin Female|Rated for 2x HDD
J15|LAN|RJ45|Gigabit Ethernet
J16|DC connector|Kycon 4-Pin Mini-DIN|DC input 12V / 8A
J17|Fan|4x1 Pin Male Header|PWM and RPM support
J18|LED Panel|5x2 Pin Male Header|Expansion port of on-board LED
J19|HDD Power|Molex 4-Pin Female|Rated for 2x HDD
SW1|Boot Mode|Dip Switch|Boot mode selector :<br> SPI,MMC,UART,SATA
SW2|LED Mode|Dip Switch|LED mode selection :<br> board or expansion panel
U3|microSD|Push-Push card connector|Support SDHC and SDXC
U4|USB 3.0|Dual Port USB3.0|Type A
U16|Reset|Push Button|CPU Reset
U10|SATA|SATA 3.0|Port 0 (SATA1)
U11|SATA|SATA 3.0|Port 1 (SATA2)
U12|SATA|SATA 3.0|Port 2 (SATA3)
U13|SATA|SATA 3.0|Port 3 (SATA4)

## Boot Modes

Helios4 supports 4 boot modes that can be chosen by using the dipswitch SW1.

![Dipswitch modes](/img/hardware/dipswitch_modes.jpg)

All the ready-to-use images we provide are for the **SD Card** boot mode.

Please refer to [U-boot](/uboot) section to know how to use the other modes.

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

![Dipswitch LED](/img/hardware/dipswitch_led.jpg)

## Reset Button

Helios4 board provides a RESET push button (U16) to hard reset the SoC (System-On-Chip).

![Reset Button](/img/hardware/reset_button.jpg)

!!! Important
    This button only resets the SoC and not the overall board. For instance it won't reset the HDD.

## HDD Recommendation List

We recommend HDD which are designed for NAS (Network Attached Storage). Those NAS HDD are specially conceived for reliable 24/7 operation and offers lower power consumption and dissipation, less vibration and noise, and finally better warranty. We recommend the following models :

**Western Digital** : WD Red NAS (1, 2, 3, 4, 6, 8 and 10TB)

- WD10EFRX
- WD20EFRX
- WD30EFRX
- WD40EFRX
- WD60EFRX
- WD80EFRX
- WD100EFRX

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
