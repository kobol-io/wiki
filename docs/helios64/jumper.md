## Boot Mode (P10 & P11) 


Helios64 supports at least **3 (TBD)** boot modes that can be chosen by using the jumper configuration.

The default Boot device order for Helios64 is the SPI Flash Memory, eMMC, then micro-SD Card.
The SoC will access this order sequentially to find the bootloader in all possible storage medium.
To change the boot order if the bootloader are present in all possible volatile storage, we can use the combination of P10 and P11 jumpers.
(Please see above figure for the connector/interface list.)

![Bootmode location](/helios64/img/jumper/p11-jumper.png)

Following jumper are available in the Helios64 board to configure the boot modes:

- P11 jumper can be used disable SPI Flash, when this jumper is shorted/close it means disable boot from the SPI Flash, and the board will search the next boot device (which is eMMC). 
- P10 jumper is available to disable eMMC boot, when this jumper is closed Helios64 wil skip looking for bootloader from the eMMC and will continue with the micro-SD card,

So you can select to search for bootloader starting from the SPI Flash Storage, eMMC, untill micro-SD card.
Following table may simplified boot ordering by jumper config by assuming the bootloaders are present in every storage device:

P11 State|P10 State|Boot Order|Notes
-----|---------------|--------------|-------
0|0|SPI Flash|-
1|0|eMMC|-
1|1|micro-SD Card|-

!!! note
	Please note, in case of bootloader is not present in the storage devices. The SoC will search to the next possible boot device.


All the ready-to-use images we provide are for the **SD Card** boot mode.

Please refer to [U-boot](/helios4/uboot) section to know how to use the other modes.

## HS Select (P13)

![HS Select location](/helios64/img/jumper/p13-jumper.png)

When this jumper closed the High Speed USB (USB 2.0) connection to the SoC will be establised, while the serial console is disconnected, so you can use flashing technology such as rockusb and maskrom in the USB type-C port.

[comment]: <> (its also called as HS select, when this jumper is closed the micro USB-C connector become type-C HS (open = console), your USB-C cable will connected to the serial console of the Helios64 board by default. By closing this connection the USB-C connection will become the HS mode, the eMMC will be detected as the USB Mass storage in your PC, in this configuration can directly flash the Armbian image to it.)


## Power Supply Priority Jumper (P14 & P15)

![P14 location](/helios64/img/jumper/p14-jumper.png)

| P15 | P14 | Description |
|-----|-----|-------------|
| Open  | Open  | O-Ring Connection |
| Open  | Close | Set ATX Priority |
| Close | Open  | Set AC Adapter Priority |
| Close | Close | Self Locking Priority |


## SATA Controller Flash MUX (P8)

Production usage only.


## eFuse Power Enable (P9)

![P9 location](/helios64/img/jumper/p9-jumper.png)

Short this jumper using tweezer to burn the efuse data on maskrom mode.

!!! warning
	Wrong efuse data can brick Helios64. Do NOT short this jumper on normal use! 
