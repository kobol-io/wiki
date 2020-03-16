
There are two types of batteries on Helios64 board:

- Li-Ion

- Coin-type Battery (CR 1225)

## Li-Ion Battery

The Li-Ion battery is actually installed in to Helios64 casing, but the battery is connected to the board in following connector:

![LBattery](/helios64/img/hardware/lbat.jpg)

The actual cell of the this Li-Ion battery is the panasonic NCR18650BD, we use 2 cell in 2S1P configuration.
So the Li-Ion battery is rated at 2980mAh, 8.4Volt.
The time estimation to fully charge this battery is 8.5 Hours.

### Pinout of the BATT Header

![LBattery](/helios64/img/hardware/batt-pinout.png)

|Pin |Name
|----|----------
|  1 |Thermistor
|  2 |Battery +
|  3 |Battery +
|  4 |GND
|  5 |Battery -
|  6 |Battery -


## Coin Cell Battery

The Location of coin-type battery is shown by this figure:
![CBattery](/helios64/img/hardware/cbat.jpg)

The battery type is CR1225, this device has diameter of 12.5mm and 2.5mm thickness.
In above figure the positive (+) polarity is heading downward to the CPU heatsink side.
This battery is used only for keep the RTC (Real Time Clock) running.


## Notes related to battery

!!! note
	To be confirmed whether RTC is still running with Li-Ion battery only.

The Li-Ion battery is not designed to make Helios64 as portable device that can be used without AC power line, but designed as backup power to perform graceful shutdown or hibernate in case of loss of AC power line.
Therefore it is normal if Helios64 turned on for a while when you press power button without AC power line.

