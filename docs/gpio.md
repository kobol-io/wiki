
## User Accessible GPIOs (J12)

Helios4 provides 12 GPIOs on header J12 which can be used for user application. Those GPIOs are provided via an 16-bit IO Expander [PCA9655E](http://www.onsemi.com/PowerSolutions/product.do?id=PCA9655E) connected to I2C bus 0.

![J12 Pinout](/img/gpio/gpio_pinout_j12.png)

### Pinout Table

| Pin | Port | Remarks |
|------------|----------|---------|
| 1 |    -   |   3.3V supply  |
| 2 | IO0_2  |    |
| 3 | IO0_3  |    |
| 4 | IO0_4  |    |
| 5 | IO0_7  |    |
| 6 | IO1_0  |    |
| 7 | IO1_1  |    |
| 8 | IO1_2  |    |
| 9 | IO1_3  |    |
| 10 | IO1_4  |    |
| 11 | IO1_5  |    |
| 12 | IO1_6  |    |
| 13 | IO1_7  |    |
| 14 |   -    | GND |

!!! warning
    Ports **IO0_0**, **IO0_1**, **IO0_5**, and **IO0_6** are reserved for system use.

!!! important
    It is not advisable to access the I2C IO Expander directly using I2C utilities.

## Accessing GPIOs under Linux

If the kernel supports debugfs (*CONFIG_DEBUG_FS=y*), list of GPIOs can be retrieved with the following command

```bash
sudo cat /sys/kernel/debug/gpio
```

Look for the **gpiochip2: GPIOs XXX-YYY** section, whereas **XXX** is first GPIO number and **YYY** is last GPIO number of IO expander.


```
gpiochip2: GPIOs 496-511, parent: i2c/0-0020, pca9555, can sleep:
 gpio-496 (                    |board-rev-0         ) in  lo    
 gpio-497 (                    |board-rev-1         ) in  lo    
 gpio-498 (                    |(null)              ) out hi    
 gpio-499 (                    |(null)              ) in  hi    
 gpio-500 (                    |(null)              ) in  hi    
 gpio-501 (                    |usb-overcurrent-stat) in  hi    
 gpio-502 (                    |USB-PWR             ) out hi    
 gpio-503 (                    |(null)              ) in  hi    
 gpio-504 (                    |(null)              ) in  hi    
 gpio-505 (                    |(null)              ) in  hi    
 gpio-506 (                    |(null)              ) in  hi    
 gpio-507 (                    |(null)              ) in  hi    
 gpio-508 (                    |(null)              ) in  hi    
 gpio-509 (                    |(null)              ) in  hi    
 gpio-510 (                    |(null)              ) in  hi    
 gpio-511 (                    |(null)              ) in  hi    
```

Another way to get first GPIO number of the IO expander

```
cat /sys/bus/i2c/devices/0-0020/gpio/gpiochip*/base
```

Therefore the mapping between header J12 Pins and Sysfs GPIO numbers will be as described in the following table

### GPIO Table

| Pin | Sysfs GPIO number | Remarks |
|----|-----|---------|
|  1 |  -  |   3.3V supply  |
|  2 | 498 |    |
|  3 | 499 |    |
|  4 | 500 |    |
|  5 | 503 |    |
|  6 | 504 |    |
|  7 | 505 |    |
|  8 | 506 |    |
|  9 | 507 |    |
| 10 | 508 |    |
| 11 | 509 |    |
| 12 | 510 |    |
| 13 | 511 |    |
| 14 |  -  |  GND |

!!! note
    The mapping table is unlikely to change between Kernel version.


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

#### Example

Set IO1_7 (pin 13) output as high

```
echo 511 | sudo tee -a /sys/class/gpio/export
echo "out" | sudo tee -a /sys/class/gpio/gpio511/direction
echo 1 | sudo tee -a /sys/class/gpio/gpio511/value
```
