## I2C Overview

Helios64 support I2C bus for the low-speed communication between devices like microcontrollers, EEPROMs, A/D and D/A converters, I/O interface and other similar peripherals in embedded systems.
In order to communicate with each I2C slave device you will need an address and communication scenario.

Please take caution of the reserved address when you use the I2C interface, below is the reseved address list:

Slave Address |	R/W Bit |	Description
--------------|---------|-------------------
000 0000 |	0  |	General call address
000 0000 |	1  |	START byte(1)
000 0001 |	X  |	CBUS address(2)
000 0010 |	X  |	Reserved for different bus format (3)
000 0011 |	X  |	Reserved for future purposes
000 01XX |	X  |	Hs-mode master code
111 10XX |	X  |	10-bit slave addressing
111 11XX |	X  |	Reserved for future purposes


## I2C bus on Helios64 / RK3399

The I2C controller on RK3399 support following features:

- 9 on-chip I2C controllers
- Multi-master I2C operation
- Support 7bits and 10bits address mode
- Serial 8bits oriented and bidirectional data transfers can be made
- Software programmable clock frequency
- Data on the I2C-bus can be transferred at rates of up to 100 kbit/s in the Standardmode, up to 400 kbit/s in the Fast-mode or up to 1 Mbit/s in Fast-mode Plus.


## Internal Bus (system reserved, NOT for user application)

In the implementation, we divide the I2C controller into 2 category.
The first implementation is for system (internal bus) and the other one is for user application (external).
Below figure describe the I2C Map inside the board:

Bus 0:

Slave   | Address  | Description|
------- | ------   |------      |
RK808-D | 0x1b     |            |
SYR837  | 0x40     |            |
SYR838  | 0x41     |            |


Bus 2:

Slave   | Address  | Description|
------- | ------   |------      |
NCT75   | 0x4c     |            |
PCA9655 | 0x21     |            |

Bus 4:

Slave   | Address  | Description|
------- | ------   |------      |
FUSB302 | 0x22     |            |

Above bus number and also including bus number 1,3,5 are reserved for system use, therefore not accessible to the user.

!!! Warning
    This bus number and address should not be accessed directly by user. Incorrect configuration can damaged the board!

## External Bus

Helios64 exposed Bus number 7 and 8 of the I2C in **P2** and **P1** pinout, respectively.
This I2C bus can be connected to the external devices.

As described on below figure of I2C (pin header number *3* and *4*), user can access the device at bus number 7.
For the UEXT (pin header number *5* and *6*), user can access the device at bus number 8.

All the I2C bus in the board are using voltage level of 3.3V, please notice Helios64 is integrated with level translator and pull up resistor.

### I2C at P1 Header

Helios64 board exposes the SoC I2C Bus 1, on header **P1**. Below is the header pin-out.

![I2C Pinout](/helios64/img/i2c/i2c_pinout.png)

This I2C device working with 3 pin bus (SDA, SCK, and GND), and also in band addressing.
We can use a 7 bit addressing to distinguish every device, but some address is reserved for the internal communication of the Helios64 board.

### I2C at UEXT

The I2C header bus also can be found at UEXT connector (can be found at **P2** header at the the board [overview](/helios64/hardware/overview) page) on the header number 5 and 6.
Below is the detail description of the UEXT connector:

![I2C at UEXT](/helios64/img/uext/UEXT_pinout.png)

Pin No  | Description
--------|-------------
1|3.3V
2|GND
3|TXD (UART)
4|RXD (UART)
5|SCL (I2C)
6|SDA (I2C)
7|MISO (SPI)
8|MOSI (SPI)
9|SCK (SPI)
10|SSEL (SPI)

## Usage under Linux

### External bus block device under linux

Below table describe the external bus of I2C under Linux,

Bus number | Device Block | Description  |
-----------|--------------|--------------|
 7         | /dev/i2c-7   |              |
 8         | /dev/i2c-8   |              |


### Checking the I2C Communication under linux

In order to communicate with the I2C devices, first we need to identify the I2C bus.
By performing scan you can see wether system detect the devices.

We can follow this step to perform the scanning process:

1. Install the Linux i2c tools.

```
$ sudo apt-get install i2c-tools
```

2. Use **i2cdetect** tool to scan I2C Bus 8.

```
root@helios64:~# i2cdetect -y 8

     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- 3c -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --   
```

Here we can see there is a device detected at the address 0x3c. If you have connected more than just one I2C device on the **P1** header, there will be more device with different address detected on the bus.


### Application example

We have demonstrated the use of I2C bus of our board in the OLED application, as shown in the [I2C(OLED)](/helios4/i2c/) page you can communicate to the external device by using the external I2C bus.
