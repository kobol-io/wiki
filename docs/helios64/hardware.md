## Block Diagram

### Helios64 Board
![!Block Diagram](/helios64/img/hardware/helios64_block_diagram.png)

### RK3399 System-On-Chip
![!Block Diagram](/helios64/img/hardware/rk3399_block_diagram.png)

This block diagram is cited from the RK3399 website documentation. [1](http://opensource.rock-chips.com/wiki_File:RK3399_Block_Diagram.png)

## Connector / Interface List

![!Board Legend](/helios64/img/hardware/helios64_board_labeled.jpg)

| Name | Peripheral Type | Connector Type | Details |
|-----|---------------|--------------|-------|
| P8 | [SATA Cont. Mem. Flash Enable Jumper](/helios64/jumper/#sata-controller-flash-mux-p8) | 2x1 Pin Header | Sata Controller Flash Memory Enable |
| P9 | [eFuse Dis. Jumper](/helios64/jumper/#efuse-power-enable-p9) | Not Populated | eFuse Power Supply |
| P10 | [eMMC Dis. Jumper](/helios64/jumper/#boot-mode-p10-p11) | 2x1 Pin Male Header | Disable eMMC boot |
| P11 | [SPI Flash Dis. Jumper](/helios64/jumper/#boot-mode-p10-p11) | 2x1 Pin Male Header | Disable SPI Flash |
| P13 | [HS Select Jumper](/helios64/jumper/#hs-select-p13) | 2x1 Pin Male Header | USB-C HS Select (Close = Type C HS, Open = Console) |
| P14 | [ATX Priority Jumper](/helios64/jumper/#power-supply-priority-jumper-p14-p15) | 2x1 Pin Male Header | ATX Supply Priority |
| P15 | [ACDC Priority Jumper](/helios64/jumper/#power-supply-priority-jumper-p14-p15) | 2x1 Pin Male Header | ACDC(AC Adapter) Supply Priority |
| USB 3.0 | [USB3 Host](/helios64/usb/#usb-on-helios64) | USB 3.0 Host | USB 3.0 Port Header  |
| SATA1 | SATA | SATA 3.0 | Port 0 (SATA1) |
| SATA2 | SATA | SATA 3.0 | Port 1 (SATA2) |
| SATA3 | SATA | SATA 3.0 | Port 2 (SATA3) |
| SATA4 | SATA | SATA 3.0 | Port 3 (SATA4) |
| SATA5 | SATA | SATA 3.0 | Port 4 (SATA5) |
| HDD_PWR | HDD Power Conn. | 8 Pin ATX 12V | Rated for 5x HDD |
| BATT | [Battery Power Conn.](/helios64/battery/#li-ion-battery) | 6 Pin ATX 12V | Battery Backup |
| ATX_4P | ATX Power Supply Conn. | 4 Pin ATX 12V | 4 Pin ATX Power Connector |
| 1Gbps ETH | LAN1 | RJ45 | Gigabit Ethernet |
| 2.5Gbps ETH | LAN2 | RJ45 | 2.5 Gigabit Ethernet |
| MICRO SD | microSD | Push-Push card connector | Support SDHC and SDXC |
| USB-C| [USB Type-C Dual Role](/helios64/usb/#usb-type-c-functionality-on-helios64) | USB Type-C Connector | Via onboard FTDI USB-to-UART0 bridge |
| PWR CON | DC Connector | Kycon 4-Pin Mini-DIN | DC input 12V / 8A |
| FAN1 | [Fan Connector](/helios64/fan/) | 4x1 Pin Male Header | PWM and RPM support |
| FAN2 | [Fan Connector](/helios64/fan/) | 4x1 Pin Male Header | PWM and RPM support |
| P1 | [I2C Header](/helios64/i2c/#i2c-at-p1-header) | 4x1 Pin Male Header | I2C Bus 1 |
| P2 | [UEXT Header](/helios64/uext/) | 2x5 Pin Male Header | Universal EXTension Support [2] |
| P3 | [Front Panel Header](/helios64/front-panel/) | 12x2 Pin Male Header | PWM and RPM support |
| P4 | Buzzer Header | 2x1 Pin Header | Buzzer Speaker Support |
| P5 | [GPIO Pin Header](/helios64/gpio/) | 7x2 Pin Male Header | GPIO configurable as input or output<br>Via IO Expander on I2C Bus 0 |
| PWR BTN | [Power Button](/helios64/button/#power-button) | Push Button | Power Button |
| RECOVERY | [Recovery Button](/helios64/button/#recovery-button) | Push Button |  |
| RST BTN | [Reset Button](/helios64/button/#reset-button) | Push Button | Reset Button |

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
