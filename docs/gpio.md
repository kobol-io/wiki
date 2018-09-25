
## User Accessible GPIOs (J12)

Helios4 provide 12 GPIOs on J12 header that are free to use for user application. This header connected to 16-bit IO Expander [PCA9655E](http://www.onsemi.com/PowerSolutions/product.do?id=PCA9655E) using I2C bus 0.

![J12 Pinout](/img/hardware/gpio_pinout_j12.png)

| Pin | GPIO number | Remarks |
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
    **IO0_0**, **IO0_1**, **IO0_5**, and **IO0_6** are reserved for system use. It is not advisable to access the I2C IO expander directly using I2C.

## LED Expansion (J18)

Helios4 board was designed to either use the on-board LEDs or use custom expansion panel (not-available). To use the header insure to switch to OFF the DIP switch SW2.

![Dipswitch LED](/img/hardware/dipswitch_led_off.png)

- - -

![J18 Pinout](/img/hardware/gpio_pinout_j18.png)

| Pin | LED number | Remarks |
|------------|----------|---------|
|  1 |  -   |  3.3V supply  |
|  2 |  -   |  Not connected |
|  3 | LED1 | Heartbeat LED  |
|  4 | LED2 | System Fault LED  |
|  5 | LED3 | SATA port 1 LED  |
|  6 | LED4 | SATA port 2 LED  |
|  7 | LED5 | SATA port 3 LED  |
|  8 | LED6 | SATA port 4 LED  |
|  9 | LED7 | USB activity LED  |
| 10 |  -   | GND |


## Accessing GPIOs under Linux

If the kernel support debugfs (*CONFIG_DEBUG_FS=y*), list of GPIOs can be accessed using

`sudo cat /sys/kernel/debug/gpio`

and look for

`gpiochip2: GPIOs XXX-YYY, parent: i2c/0-0020, pca9555, can sleep:`

whereas **XXX** is first GPIO number and **YYY** is last GPIO number of IO expander.

- - -

Another way to get first GPIO number of the IO expander

`cat /sys/bus/i2c/devices/0-0020/gpio/gpiochip*/base`

- - -

** J12 assigned GPIO number in sysfs **

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

!!! info
    The GPIO number listed on the table most likely would not changed between kernel version.


Declare GPIO number to be use.

`echo N | sudo tee -a /sys/class/gpio/export`

Set the direction, "out" as output and "in" as "input".

`echo DIRECTION | sudo tee -a /sys/class/gpio/gpioN/direction`

To read current GPIO input

`cat /sys/class/gpio/gpioN/value`

Write 0 or 1 to GPIO

`echo VALUE | sudo tee -a /sys/class/gpio/gpioN/value`

!!! notes
    Pay attention to the path, /sys/class/gpio/gpio**N**/

### Example

Set IO1_7 (pin 13) output as high

```
echo 511 | sudo tee -a /sys/class/gpio/export
echo "out" | sudo tee -a /sys/class/gpio/gpio511/direction
echo 1 | sudo tee -a /sys/class/gpio/gpio511/value
```
