## Boot Mode (P10 & P11) 

![Bootmode location](/helios64/img/jumper/p11-12-jumper.png)

Refer to [Boot Mode](/helios64/boot_mode)


## HS Select (P13)

![HS Select location](/helios64/img/jumper/p13-jumper.png)

When this jumper closed the High Speed USB (USB 2.0) connection to the SoC will be establised, while the serial console is disconnected, so you can use flashing technology such as rockusb and maskrom in the USB type-C port.

[comment]: <> (its also called as HS select, when this jumper is closed the micro USB-C connector become type-C HS (open = console), your USB-C cable will connected to the serial console of the Helios64 board by default. By closing this connection the USB-C connection will become the HS mode, the eMMC will be detected as the USB Mass storage in your PC, in this configuration can directly flash the Armbian image to it.)


## Power Supply Priority Jumper (P14 & P15)

| P15 | P14 | Description |
|-----|-----|-------------|
| Open  | Open  | O-Ring Connection |
| Open  | Close | Set ATX Priority |
| Close | Open  | Set AC Adapter Priority |
| Close | Close | Self Locking Priority |


## SATA Controller Flash MUX (P8)

Production usage only.


## eFuse Power Enable (P9)

Short this jumper using tweezer to burn the efuse data on maskrom mode.

!!! warning
	Wrong efuse data can brick Helios64. Do NOT short this jumper on normal use! 