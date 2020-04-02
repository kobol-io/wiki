## User Accessible GPIOs (P5)

Helios64 provides 22 GPIOs on header P5 which can be used for user application.
Those GPIOs are provided via an 16-bit IO Expander [PCA9655E](http://www.onsemi.com/PowerSolutions/product.do?id=PCA9655E) connected to I2C bus 2.

Unlike Helios4 whereas some pin of IO expander is used for system usage, on Helios64 all 16 GPIOs can be used for user application.

![P5 Pinout](/helios64/img/gpio/gpio.jpg)

## Pinout Table

| PIN | Port | Remarks |
|-----|------|-------------|
| 1   | - | 3.3V Supply |
| 2   | - | 5V Supply |
| 3   | - | GND |
| 4   | EXP_P0_0 | |
| 5   | EXP_P0_1 | |
| 6   | EXP_P0_2 | |
| 7   | EXP_P0_3 | |
| 8   | EXP_P0_4 | |
| 9   | EXP_P0_5 | |
| 10  | EXP_P0_6 | |
| 11  | EXP_P0_7 | |
| 12  | EXP_P1_0 | |
| 13  | EXP_P1_1 | |
| 14  | EXP_P1_2 | |
| 15  | EXP_P1_3 | |
| 16  | EXP_P1_4 | |
| 17  | EXP_P1_5 | |
| 18  | EXP_P1_6 | |
| 19  | EXP_P1_7 | |
| 20  | - | GND |
