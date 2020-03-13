## M2 Connector (P2)

There is at least two type of batteries which is installed in Helios64 board: 
- Li-Ion
- Coin-type Battery (CR 1225)

### Li-Ion Battery

The Li-Ion battery is actually installed in to Helios64 caseing, but the battery is connected to the board in following connector:

![LBattery](/helios64/img/hardware/lbat.jpg)

The actual cell of the this Li-Ion battery is the panasonic NCR18650BD, we use 2 cell in serial configuration.
So the Li-Ion battery is rated at 2980mAh, 8.4Volt.
The time estimation to full charge this battery is 8.5 Hours.

#### Pinout of the BATT Header

![LBattery](/helios64/img/hardware/batt-pinout.png)

|Pin |Name
|----|----------
|  1 |Thermistor
|  2 |Battery +
|  3 |Battery +
|  4 |GND
|  5 |Battery -
|  6 |Battery -


### Coin Cell Battery

The Location of coin-type battery is shown by this figure: 
![CBattery](/helios64/img/hardware/cbat.jpg)

The battery type is CR1225, this device has diameter of 12.5mm and 2.5mm thickness.
In above figure the positive (+) polarity is heading downward to the CPU heatsink side.
This battery is used only for keep the RTC (Real Time Clock) running.


### Notes related to battery 

**To Be Confirmed**
We have NOT confirmed the operaiton of the RTC without CR1225 Coin Cell Battery, even in the situation with the Li-Ion connected we have NOT the operation of RTC.

The Li-Ion battery design is not for powering device when the main AC supply is disconnected, but as the device support to perform graceful shutdown or hibernate.
Therfore if you found this device can actually turned on for a while when you push the power button, in the situation the Li-Ion battery is connected (when the main AC power disconnected), this is totally normal situation.

