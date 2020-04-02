
## UPS Introduction

## Li-Ion Battery

The Li-Ion battery is actually installed in to Helios64 casing, but the battery is connected to the board in following connector:

![LBattery](/helios64/img/ups/lbat.jpg)

The actual cell of the this Li-Ion battery is the panasonic NCR18650BD, we use 2 cell in 2S1P configuration.
So the Li-Ion battery is rated at 2980mAh, 8.4Volt.
The time estimation to fully charge this battery is 8.5 Hours.

### Pinout of the BATT Header

![LBattery](/helios64/img/ups/batt-pinout.png)

|Pin |Name
|----|----------
|  1 |Thermistor
|  2 |Battery +
|  3 |Battery +
|  4 |GND
|  5 |Battery -
|  6 |Battery -

## Notes related to battery

The Li-Ion battery is not designed to make Helios64 as portable device that can be used without AC power line, but designed as backup power to perform graceful shutdown or hibernate in case of loss of AC power line. Therefore it is normal if Helios64 turned on for a while when you press power button without AC power line.
