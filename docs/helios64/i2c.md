### Check I2C Communication

To check if the system can communicate with the I2C device, we should first scan the I2C bus to see if we can detect the device.

1. Install the Linux i2c tools.

```
$ sudo apt-get install i2c-tools
```

2. Use **i2cdetect** tool to scan I2C Bus 1.

```
root@helios64:~# i2cdetect -y 1

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

Here we can see there is a device detected at the address 0x3c. We can conclude is our OLED screen, unless you have connected more than just one I2C device on the **J9** header.
