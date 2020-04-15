# Power Management IC (PMIC)

The Rockchip RK808-D is a specially designed Power Management IC (PMIC) for the RK3399 System-on-Chip (SoC). The highly integrated device includes 4x buck DC-DC converters, 8x high performance LDOs, 2x low RDS switches, I2C interface, programmable power sequencing and an Real time clock (RTC).

## Features

* Input voltage range: 2.7V to 5.5V
* 2MHz Switching Frequency for bucks
* Current mode architecture for best transient performance
* Internal compensation and soft start
* I2C Programmable output levels and power sequencing
* Real time clock (RTC)
* High efficiency architecture
* Integrated Vout Discharge Circuit for BUCK and LDO
* Power:
    + CH1: Synchronous Buck regulator, 5A max
    + CH2: Synchronous Buck regulator, 5A max
    + CH3: Synchronous Buck regulator, 3A max
    + CH4: Synchronous Buck regulator, 2.5A max
    + CH6,CH7,CH9,CH11: Linear regulators, 150mA max
    + CH8: Low noise and high PSRR linear regulator,100mA max
    + CH10,CH12,CH13: Linear regulators, 300mA max
    + CH14: Low RDS switch, 0.2ohm@Vgs=3v
    + CH15: Low RDS switch, 0.2ohm@Vgs=3v
* Flexible Power Sequence control

## Block Diagram

![RK808-D Diagram](/helios64/img/pmic/rk808d-diagram.png)
