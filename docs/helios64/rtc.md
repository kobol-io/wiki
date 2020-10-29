# Real Time Clock (RTC)

Helios64 has an on-board RTC clock which is provided by the Power Management IC (PMIC) RK808-D. The RTC functions provided by the PMIC include second/minute/hour/day/month/year information, alarm wake up as well as time calibration.

![RTC](/helios64/img/rtc/rtc_diagram.jpg)

The SoC receive clock signal from the PMIC RTC and in the meantime access the PMIC RTC functions over I2C bus.

## RTC Battery

To save time information and allow the RTC to keep running while system is powered off, the PMIC RTC relies on a dedicated coin battery located at BAT1. The battery holder (BAT1) accepts CR1225 battery model.

!!! Note
    The polarity of the battery holder is indicated on the PCB with **'+'** signs.

![RTC Battery](/helios64/img/rtc/rtc_battery.jpg)

However if your setup has the [UPS](/helios64/ups/) battery connected, then RTC battery is not required since the RTC clock can also be kept powered by the UPS battery.

## Scheduled Power On using RTC

User can set up a scheduled power on using RTC alarm.

### Use SYSFS

Run following command to check whether there is any alarm set,

```bash
cat /sys/class/rtc/rtc0/wakealarm
```
If nothing return, it means no alarm set.

To reset/disable the alarm, run:

```bash
echo 0 | sudo tee /sys/class/rtc/rtc0/wakealarm
```

The alarm only accepts Unix epoch time. We can use *[date](https://linux.die.net/man/1/date)* utility as helper to get epoch time of our calendar.

To set alarm from absolute calendar time, run:

```bash
echo `date '+%s' -d '20 December 2020 02:14:10 PM'` | sudo tee /sys/class/rtc/rtc0/wakealarm
```
You can also set alarm from relative time using this command:

```bash
echo `date '+%s' -d '+ 1 hour 2 minutes 10 seconds'` | sudo tee /sys/class/rtc/rtc0/wakealarm
```

After alarm set, you can power off the system and keep the power plugged in. Helios64 should automatically power on at the scheduled time.

### Use rtcwake

Run following command to check whether there is any alarm set:

```bash
sudo rtcwake -m show
```

To reset/disable the alarm, run:

```bash
sudo rtcwake -m disable
```

To set alarm from absolute calendar time, run:

```bash
sudo rtcwake -m off --date '2020-12-20 14:14:10'
```

You can also set alarm from relative time using this command:

```bash
sudo rtcwake -m off --date '+ 1 hour 2 minutes 10 seconds'
```

After the command successfully executed, system will shutdown. Keep the power plugged in and Helios64 should autommatically power on at the scheduled time.

## References

[date- Linux manual page](https://linux.die.net/man/1/date)

[rtcwake - Linux manual page](https://linux.die.net/man/8/rtcwake)
