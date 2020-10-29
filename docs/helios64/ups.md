# UPS (Uninterruptible Power Supply)

Helios64 provides a built-in UPS feature to protect your data from unexpected power loss. The feature requires an additional Li-Ion Battery to be connected to header J9 .

![J9 Location](/helios64/img/ups/j9.jpg)

## Feature

When system detects AC power loss, the system will switch instantly to battery mode. The system is able to fully run (including HDDs) on battery for up to 15 min. During that time, if AC power comes back, system will switch back to AC power mode. Else, if AC power is not resuming and battery voltage reach a certain low threshold, the system will automatically trigger graceful shutdown or hibernation (system-to-disk).

## Li-Ion Battery

As part of Helios64 accessories, we provide a specially designed Li-Ion Battery for the UPS feature (SKU: H64-BAT-01 ).

![Li-Ion Battery](/helios64/img/ups/battery.jpg)

The actual cells of the this battery pack is the *Panasonic NCR18650BD*, we use 2x cells in 2S1P configuration. The battery pack is equipped with a protection IC (HY2120) and a thermistor to monitor the cell temperature.

The battery pack is rated 7.2V 3180mAh (22.9Wh) with max continuous discharge of 10A.

!!! Info
    It's possible for users to build their own battery if they respect the same above specification and pinout.

## J9 Header Pinout

![j9 Pinout](/helios64/img/ups/j9_pinout.jpg)

|Pin |Name      |
|----|----------|
|  1 |Thermistor |
|  2 |Battery + |
|  3 |Battery + |
|  4 |GND |
|  5 |Battery - |
|  6 |Battery - |

## Charge Management

Battery charge is fully managed by hardware ([Texas Instrument BQ24133](https://www.ti.com/product/BQ24133)), no software required. Charging function still operates when system is powered off. Helios64 board provides a visual charging indicator on LED9.

|LED State | Description |
|-----------|-------------|
|  On |Charging |
|  Off | Charge complete |
|  Blinking | Fault / Battery Absent |

**Note:** The estimated time to fully charge the empty battery is around 4 hours.

## UPS Status Under Linux

In Linux, the UPS is declared as gpio-charger located at
`/sys/class/power_supply/gpio-charger`


### Main Power Status

Main Power status can be read using

```bash
cat /sys/class/power_supply/gpio-charger/online
```

**1** means power adapter supplying the power.

**0** means loss of power, power adapter no longer supplying power.

### Charging Status

!!! Note
    This status is unavailable on Linux Kernel 4.4

Battery charging status can be read using

```bash
cat /sys/class/power_supply/gpio-charger/status
```

It will return **Charging** or **Not Charging**

!!! Info
    The status is only **valid** when main power is available.

    *Fault / Battery Absent* status is unavailable but it can be concluded if the status keep changing.

### Battery Level

Battery voltage can be measured on internal ADC channel 2. The internal ADC is located at
`/sys/bus/iio/devices/iio:device0`

![!Battery level](/helios64/img/ups/battery_level_schematic.png)


Following table shows scaling between ADC reading and actual battery voltage

| Battery Voltage (V) | ADC reading (mV) | Remarks |
|---------------------|------------------|---------|
|  0                  |  114             | No batteries |
|  7.0                |  916             | Recommended threshold to force shutdown system |
|  8.4                | 1099             | Fully Charge |

[IIO subsystem](https://www.kernel.org/doc/html/latest/driver-api/iio/index.html) provides hardware raw value. To convert the raw value to standard units, use following formula

`adc = in_voltage2_raw * in_voltage_scale`

To get the actual ADC reading in shell run following command

```bash
echo "`cat /sys/bus/iio/devices/iio:device0/in_voltage2_raw` * `cat /sys/bus/iio/devices/iio:device0/in_voltage_scale`" | bc
```
