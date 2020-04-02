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
| J1 | [USB 3.0](/helios64/usb/#usb-on-helios64) | USB 3.0 Type-A | USB 3.0 Port 3  |
| J2 | [M.2 SATA](/helios64/sata/) | M.2 Key-B | M.2 Slot for SATA SSD<br> or USB 2.0 Device |
| J3 | [SATA](/helios64/sata/) | SATA 3.0 | Port 0 (SATA1) |
| J4 | [SATA](/helios64/sata/) | SATA 3.0 | Port 1 (SATA2) |
| J5 | [SATA](/helios64/sata/) | SATA 3.0 | Port 2 (SATA3) |
| J6 | [SATA](/helios64/sata/) | SATA 3.0 | Port 3 (SATA4) |
| J8 | [SATA](/helios64/sata/) | SATA 3.0 | Port 4 (SATA5) |
| J7 | HDD Power | 8 Pin Mini-Fit Jr | HDD Power 5V + 12V<br>(supports 5x HDD) |
| J9 | [UPS Battery](/helios64/battery/#li-ion-battery) | 6 Pin Mini-Fit Jr | UPS Battery Power |
| J10 | ATX PSU | 4 Pin Mini-Fit Jr | DC input 12V |
| J11 | [LAN1](/helios64/ethernet/) | RJ45 | Gigabit Ethernet |
| J12 | [LAN2](/helios64/ethernet/) | RJ45 | 2.5 Gigabit Ethernet |
| J13 | [USB 3.0 (x2)](/helios64/usb/#usb-on-helios64) | Dual USB 3.0 Type-A | USB 3.0 Port 1 and 2  |
| J14 | microSD | Push-Push card connector | Support SDHC and SDXC |
| J15| [USB Type-C](/helios64/usb/#usb-type-c-functionality-on-helios64) | USB Type-C Connector | Supports following:<br>- DisplayPort Mode<br>- DAS Mode<br>- Host Mode<br>- Serial Console |
| J16| DC-IN | Kycon 4-Pin Mini-DIN | DC input 12V |
| P1 | [I2C](/helios64/i2c/#i2c-at-p1-header) | 4x1 Pin Header | I2C Bus |
| P2 | [UEXT](/helios64/uext/) | 2x5 Pin Header | Universal EXTension<br>(I2C, SPI and UART)|
| P3 | [Front Panel](/helios64/front-panel/) | 12x2 Pin Header | Front Panel Extension |
| P4 | Buzzer | 2x1 Pin Header | Buzzer Alarm Speaker |
| P5 | [GPIO](/helios64/gpio/) | 7x2 Pin Header | User Configurable GPIO |
| P6 | [PWM Fan](/helios64/fan/) | 4x1 Pin Header | Fan 1 with PWM support |
| P7 | [PWM Fan](/helios64/fan/) | 4x1 Pin Header | Fan 2 with PWM support |
| P8 | [SATA Ctrl. Programming](/helios64/jumper/#sata-controller-flash-mux-p8) | 2x1 Pin Header | SATA Controller Flash Enable |
| P9 | [eFuse Programming](/helios64/jumper/#efuse-power-enable-p9) | 2x1 Pin Header | eFuse Power Supply Enable |
| P10 | [eMMC Disable](/helios64/jumper/#boot-mode-p10-p11) | 2x1 Pin Header | Disable eMMC |
| P11 | [SPI Flash Disable](/helios64/jumper/#boot-mode-p10-p11) | 2x1 Pin Header | Disable SPI Flash |
| P12 | [Battery Configuration](/helios64/battery/) | 2x1 Pin Header | Enable 3S1P Battery Support  |
| P13 | [HS Select Jumper](/helios64/jumper/#hs-select-p13) | 2x1 Pin Male Header | USB-C HS Mode |
| P14 | [ATX Priority Jumper](/helios64/jumper/#power-supply-priority-jumper-p14-p15) | 2x1 Pin Male Header | ATX Supply Priority |
| P15 | [ACDC Priority Jumper](/helios64/jumper/#power-supply-priority-jumper-p14-p15) | 2x1 Pin Male Header | ACDC(AC Adapter) Supply Priority |
| SW1 | [Power Button](/helios64/button/#power-button) | Push Button | Power Button |
| SW2 | [Recovery Button](/helios64/button/#recovery-button) | Push Button | Recovery Button |
| SW3 | [Reset Button](/helios64/button/#reset-button) | Push Button | Reset Button |
