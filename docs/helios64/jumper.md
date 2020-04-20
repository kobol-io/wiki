## Boot Mode (P10 & P11)

Helios64 SoC supports 3 boot modes that can be chosen by jumper configuration.

The default boot device order is:

1. SPI Flash
2. eMMC Flash
3. micro-SD Card

The SoC will access sequentially the above devices until it finds a bootloader code. To change the boot order if a bootloader code is present on more then one device, we can use the combination of P10 and P11 jumpers to force SoC to skip devices.

![P10 P11 location](/helios64/img/jumper/p10-11-jumper.jpg)

- P11 jumper can be used to disable SPI Flash, when this jumper is shorted SoC will skip looking for bootloader on SPI Flash and will continue with the EMMC Flash.
- P10 jumper can be used to disable eMMC Flash, when this jumper is shorted SoC will skip looking for bootloader on eMMC Flash and will continue with the micro-SD card.

The following logic table gives a simplified view of boot order configuration by jumper, assuming bootloader code is present on each device:

| P11 State | P10 State | Boot Order | Notes |
|-----------|-----------|------------|-------|
| 0 | 0 | SPI Flash | - |
| 1 | 0 | eMMC Flash | - |
| 1 | 1 | micro-SD Card | - |

## USB Console/Recovery Mode (P13)

This jumper controls a 2:1 MUX switching the USB2.0 lanes of the Type-C port (J15) between the SoC Type-C interface and the USB-to-Serial bridge. For more details refer to the [USB Type-C section](/helios64/usb/#usb-on-helios64).

![P13 location](/helios64/img/jumper/p13-jumper.jpg)

* When the jumper is opened the Type-C port (J15) can be used to connect to the serial console of the Helios64.
* When closed and system in recovery mode, the Type-C port (J15) can be used to flash directly the eMMC over USB.

## DC-IN Priority (P14 & P15)

Helios64 supports 2x different DC-IN 12V inputs :

* AC Adapter (J16)
* ATX PSU (J10)

You can plug both DC-IN inputs in order to have a failover setup that automatically switch to the other input if the first one fails. Jumpers P14 and P15 can be used to configure input priority.

![P14 P15 location](/helios64/img/jumper/p14-15-jumper.jpg)

| P15 | P14 | Description |
|-----|-----|-------------|
| Open  | Open  | O-Ring Connection |
| Open  | Close | Set ATX Priority |
| Close | Open  | Set AC Adapter Priority |
| Close | Close | Self Locking Priority |


## SATA Controller Flash (P8)

Reserved for production.

## eFuse Power Enable (P9)

![P9 location](/helios64/img/jumper/p9-jumper.jpg)

When shorted this jumper will allow user to burn efuse data in order to configure secure boot.

!!! warning
		Wrong efuse data can bricked Helios64 which cannot be repaired. Do **NOT** short this jumper if you don't know what you are doing.
