Helios64 supports at least **3 (TBD)** boot modes that can be chosen by using the jumper configuration.

The default Boot device order for Helios64 is the SPI Flash Memory, eMMC, then micro-SD Card.
The SoC will access this order sequentially to find the bootloader in all possible storage medium.
To change the boot order if the bootloader are present in all possible volatile storage, we can use the combination of P10 and P11 jumpers.
(Please see above figure for the connector/interface list.)
Following jumper are available in the Helios64 board to configure the boot modes:

- P11 jumper can be used disable SPI Flash, when this jumper is shorted/close it means disable boot from the SPI Flash, and the board will search the next boot device (which is eMMC). 
- P10 jumper is available to disable eMMC boot, when this jumper is closed Helios64 wil skip looking for bootloader from the eMMC and will continue with the micro-SD card,

So you can select to search for bootloader starting from the SPI Flash Storage, eMMC, untill micro-SD card.
Following table may simplified boot ordering by jumper config by assuming the bootloaders are present in every storage device:

![Boot modes](/helios64/img/bootmode/bootmode_jumper.png)

P11 State|P10 State|Boot Order|Notes
-----|---------------|--------------|-------
0|0|SPI Flash|-
1|0|eMMC|-
1|1|micro-SD Card|-

!!! note
	Please note, in case of bootloader is not present in the storage devices. The SoC will search to the next possible boot device.


All the ready-to-use images we provide are for the **SD Card** boot mode.

Please refer to [U-boot](/helios4/uboot) section to know how to use the other modes.