Helios64 has an on-board RTC clock which is provided by the Power Management IC (PMIC) RK808-D. The RTC functions provided by the PMIC include second/minute/hour/day/month/year information, alarm wake up as well as time calibration.

![RTC](/helios64/img/rtc/rtc_diagram.jpg)

The SoC receive clock signal from the PMIC RTC and in the meantime access the PMIC RTC functions over I2C bus.

## RTC Battery

To save time information and allow the RTC to keep running while system is powered off, the PMIC RTC relies on a dedicated coin battery located at BAT1. The battery holder (BAT1) accepts CR1225 battery model.

![RTC Battery](/helios64/img/rtc/rtc_battery.jpg)

!!! Note
    The polarity of the battery holder is indicated on the PCB with **'+'** signs.
