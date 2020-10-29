Helios64 provides 16 GPIOs via a 20-Pin header (P5). Those GPIOs are provided via an 16-bit IO Expander [PCA9655E](http://www.onsemi.com/PowerSolutions/product.do?id=PCA9655E) connected to I2C bus 2.

![P5 Location](/helios64/img/gpio/gpio.jpg)

## Pinout

![P5 Pinout](/helios64/img/gpio/gpio_pinout.jpg)

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

## Accessing GPIOs under Linux

If the kernel supports debugfs (*CONFIG_DEBUG_FS=y*), list of GPIOs can be retrieved with the following command

```bash
sudo cat /sys/kernel/debug/gpio
```

Look for the **gpiochip5: GPIOs XXX-YYY** section, whereas **XXX** is first GPIO number and **YYY** is last GPIO number of IO expander.

```
gpiochip5: GPIOs 496-511, parent: i2c/2-0020, 2-0020, can sleep:   
```

Another way to get first GPIO number of the IO expander

```
cat /sys/bus/i2c/devices/2-0020/gpio/gpiochip*/base
```

Therefore the mapping between header P5 Pins and Sysfs GPIO numbers will be as described in the following table

### GPIO Table

| PIN | Sysfs GPIO number | Remarks |
|-----|------|-------------|
| 1   | - | 3.3V Supply |
| 2   | - | 5V Supply |
| 3   | - | GND |
| 4   | 496 | |
| 5   | 497 | |
| 6   | 498 | |
| 7   | 499 | |
| 8   | 500 | |
| 9   | 501 | |
| 10  | 502 | |
| 11  | 503 | |
| 12  | 504 | |
| 13  | 505 | |
| 14  | 506 | |
| 15  | 507 | |
| 16  | 508 | |
| 17  | 509 | |
| 18  | 510 | |
| 19  | 511 | |
| 20  | - | GND |

### GPIO Control

**1.** Export the GPIO number you want to use

```
echo N | sudo tee -a /sys/class/gpio/export
```

**2.** Set the direction, "out" for Output or "in" for Input

```
echo DIRECTION | sudo tee -a /sys/class/gpio/gpioN/direction
```

**3.** Now you can read or change the GPIO value

To read GPIO value

```
cat /sys/class/gpio/gpioN/value
```

To change GPIO value (only if GPIO set as Output)

```
echo VALUE | sudo tee -a /sys/class/gpio/gpioN/value
```

!!! notes
    Pay attention to the path, /sys/class/gpio/gpio**N**/ where **N** is the GPIO number.


