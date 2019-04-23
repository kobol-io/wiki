!!! warning
    Always POWER OFF the system before plug/unplug the fan. Failed to do so could damage the controlling GPIO due to power surge.

## PWM Introduction

PWM, or pulse width modulation is a technique which allows us to adjust the average value of the voltage that’s going to the electronic device by varying duty cycle of the power at a fast rate.

The term *duty cycle* describes the proportion of 'on' time to the regular interval or 'period' of time; a low duty cycle corresponds to low power, because the power is off for most of the time. Duty cycle is expressed in percent, 100% being fully on. When a digital signal is on half of the time and off the other half of the time, the digital signal has a duty cycle of 50% and resembles a "square" wave. When a digital signal spends more time in the on state than the off state, it has a duty cycle of >50%. When a digital signal spends more time in the off state than the on state, it has a duty cycle of <50%. Here is a pictorial that illustrates these three scenarios:

![PWM duty cycle](/img/pwm/pwm_duty_cycle_graph.png)

## PWM Fan Implementation

### Type-A

![Type A Curve](/img/pwm/fan_type_a_curve.jpg)

### Type-B

![Type B Curve](/img/pwm/fan_type_b_curve.jpg)

### Type-C

![Type C Curve](/img/pwm/fan_type_c_curve.jpg)

## Helios4 Fan Control Schematic

### Board Rev 1.1

![Helios4 Fan control Rev1.1](/img/pwm/fan_control_schematic_rev1_1.png)

**Remarks**

| Description | Header J10 | Header J17 | Remarks |
|-----------|---------|-----------|---------|
| PWM pin | gpio41 | gpio55 | 3.3V pull up fan **ONLY**! Early generation of 4-wire pwm fan may use 5V pull-up |
| SENSE pin | gpio43 | gpio48 | SENSE pin is not implemented yet |
| PWM Frequency | 25 kHz | 25 kHz | defined in device tree |

### Board Rev 1.2

![Helios4 Fan control Rev 1.2](/img/pwm/fan_control_schematic_rev1_2.png)

**Remarks**

| Description | Header J10 | Header J17 | Remarks |
|-----------|---------|-----------|---------|
| SENSE pin | gpio43 | gpio48 | SENSE pin is not implemented yet |
| PWM Frequency | 25 kHz | 25 kHz | defined in device tree |

## Bundled Fan

![Fan Connector](/img/pwm/fan_connector.png)

Connector Pinout

| Pin | Function | Wire Color |
|-----|----------|------------|
|  1  |    GND   |   Black    |
|  2  |    12V   |   Red      |
|  3  |   Sense  |   Yellow   |
|  4  |  Control |   Blue     |


### Type-A Fan (Batch 1 & 3)

![Type-A Fan](/img/pwm/fan_type_a_photo.jpg)

Fan Specification

|   Parameter   |  Value   | Unit | Remarks |
|---------------|----------|------|---------|
| Maximum Speed | 4200 | RPM | @ duty cycle 98% |
| Minimum Speed | 1200 | RPM | @ duty cycle 24% |
| Shut off | No | | Not Supported |
| Implementation Type | A |  |  |

![Type-A Fan Speed Graph](/img/pwm/fan_speed_graph_type_a_fan.png)

!!! info
    Duty cycle data is converted from Linux PWM

### Type-C Fan (Batch 2)

![Type-C Fan](/img/pwm/fan_type_c_photo.jpg)

Fan Specification

|   Parameter   |  Value   | Unit | Remarks |
|---------------|----------|------|---------|
| Maximum Speed | 4200 | RPM | @ duty cycle 98% |
| Minimum Speed | 400 | RPM | @ duty cycle 10% |
| Shut off | Yes |  | duty cycle  <= 5.5% and restart @ duty cycle > 9% |
| Implementation Type | C |  |  |

![Type-C Speed Graph](/img/pwm/fan_speed_graph_type_c_fan.png)

!!! info
    Duty cycle data is converted from Linux PWM

### Fan Speed Comparison

![Fan Speed Graph](/img/pwm/fan_speed_comparison.png)


## Helios4 Temperature Sensors

### CPU Thermal Sensor

Armada 388 incorporates a Thermal Management engine for monitoring die temperature. It includes an on-die analog-to-digital thermal sensor, that is used to determine when the maximum specified processor junction temperature has been reached.

### Ethernet PHY Thermal Sensor

Helios4's **10/100/1000 BASE-T PHY Tranceiver** ([Marvell 88E1512 Datasheet](http://www.marvell.com/documents/eoxwrbluvwybgxvagkkf/)) features an internal temperature sensor. The sensor reports the die temperature and is updated approximately once per second.

### Board Temp Sensor

Helios4 has a **Digital Temperature Sensor with 2‐wire Interface** ([NCT75 Datasheet](https://www.onsemi.com/pub/Collateral/NCT75-D.PDF)), located on bottom side of the board. It is used to read ambient temperature.


## PWM Fan Control under Linux

Linux use 8-bit integer to represent duty cycle. PWM value 0 represent 0% duty cycle and PWM value 255 represent 100% duty cycle.

![Duty Cycle Formula](/img/pwm/fan_duty_cycle_formula.png)

Below graphs are bundled fan speed vs pwm value instead of duty cycle.

![Type-A Fan Speed Graph](/img/pwm/fan_speed_graph_type_a_fan_linux.png)

![Type-C Fan Speed Graph](/img/pwm/fan_speed_graph_type_c_fan_linux.png)


### Patch requirement

Currently Linux gpio-mvebu driver does not allow more than 1 PWM under the same gpio bank. Helios4 uses 2 PWM under same bank therefore [this patch](https://raw.githubusercontent.com/armbian/build/master/patch/kernel/mvebu-next/92-mvebu-gpio-remove-hardcoded-timer-assignment.patch) needs to be applied to kernel source to remove the restriction.

### Using SYSFS interface

Linux export the fan control mechanism to SYSFS under hwmon class.
List of devices can be checked under /sys/class/hwmon

```
ls -l /sys/class/hwmon/
total 0
lrwxrwxrwx 1 root root 0 Nov  7 07:23 hwmon0 -> ../../devices/platform/soc/soc:internal-regs/f1072004.mdio/mdio_bus/f1072004.mdio-mii/f1072004.mdio-mii:00/hwmon/hwmon0
lrwxrwxrwx 1 root root 0 Nov  7 07:23 hwmon1 -> ../../devices/virtual/hwmon/hwmon1
lrwxrwxrwx 1 root root 0 Nov  7 07:23 hwmon2 -> ../../devices/platform/j10-pwm/hwmon/hwmon2
lrwxrwxrwx 1 root root 0 Nov  7 07:23 hwmon3 -> ../../devices/platform/j17-pwm/hwmon/hwmon3
lrwxrwxrwx 1 root root 0 Nov  7 07:23 hwmon4 -> ../../devices/platform/soc/soc:internal-regs/f1011000.i2c/i2c-0/0-004c/hwmon/hwmon4

```

!!! info
    The numbering may different from above example output. It depends on whether the driver built as kernel module or built-in, device initialization order. Take this as consideration when using [fancontrol](#fancontrol-automated-software-based-fan-speed-control)

To identify which hwmon belong to fan, look for *j10-pwm* and *j17-pwm*. On above example

```
hwmon2 -> ../../devices/platform/j10-pwm/hwmon/hwmon2
hwmon3 -> ../../devices/platform/j17-pwm/hwmon/hwmon3
```

To read current PWM
```
cat /sys/class/hwmon2/pwm1
cat /sys/class/hwmon3/pwm1
```

To set PWM
```
echo NEW_PWM_VALUE > /sys/class/hwmon2/pwm1
echo NEW_PWM_VALUE > /sys/class/hwmon3/pwm1
```

### Fancontrol - automated software based fan speed control

fancontrol is a shell script for use with lm_sensors. It reads its configuration from a file, then calculates fan speeds from temperatures and sets the corresponding PWM outputs to the computed values.

```
sudo apt-get install fancontrol
```

fancontrol includes *pwmconfig* script to create automatically a configuration file but it can not be used for Helios4.


#### UDEV rules

Since hwmon order can be changed between kernel version or even between reboot, on Armbian we use udev rules as workaround. The rules can be found from [here](https://raw.githubusercontent.com/armbian/build/master/packages/bsp/helios4/90-helios4-hwmon.rules) and to be copy to **/etc/udev/rules.d/**

#### Configuration File

fancontrol uses **/etc/fancontrol** as configuration file. Below is an example configuration to control fan speed on Helios4.

```
# Helios4 PWM Fan Control Configuration
# Temp source : armada_thermal sensor
INTERVAL=10
DEVPATH=hwmon2=devices/platform/j10-pwm hwmon3=devices/platform/j17-pwm hwmon4=devices/platform/soc/soc:internal-regs/f1011000.i2c/i2c-0/0-004c
DEVNAME=hwmon1=armada_thermal
FCTEMPS=hwmon2/pwm1=hwmon1/temp1_input hwmon3/pwm1=hwmon1/temp1_input
MINTEMP=hwmon2/pwm1=60 hwmon3/pwm1=60
MAXTEMP=hwmon2/pwm1=80 hwmon3/pwm1=80
MINSTART=hwmon2/pwm1=20 hwmon3/pwm1=20
MINSTOP=hwmon2/pwm1=29 hwmon3/pwm1=29
MINPWM=20
```

INTERVAL

This variable defines at which interval in seconds the main loop of fancontrol will be executed.

DEVPATH

Maps hwmon class devices to physical devices. This lets fancontrol check that the configuration file is still up-to-date.

It expect the **hwmonN** as symlink to **devices/***

DEVNAME

Records hwmon class device names. This lets fancontrol check that the configuration file is still up-to-date.

Since **armada_thermal** does not create symlink, use *DEVNAME* instead of *DEVPATH*

FCTEMPS

Maps PWM outputs to temperature sensors so fancontrol knows which temperature sensors should be used for calculation of new values for the corresponding PWM outputs.

Fans (**hwmon2** & **hwmon3**) are controlled based on CPU thermal sensor (**hwmon1**) reading.

MINSTART

Sets the minimum speed at which the fan begins spinning. You should use a safe value to be sure it works, even when the fan gets old.

Type-C fan restart at 15, added 5 for safety (in case of aging fan) give us **20**. The value does not affect Type-A fan.

MINSTOP

The minimum speed at which the fan still spins. Use a safe value here, too.

Type-C fan stopped at 24, added 5 for safety (in case of aging fan) give us **29**. The value does not affect Type-A fan.

-----

*Following settings can be adjusted by user to tweak further.*

MINTEMP

The temperature below which the fan gets switched to minimum speed.

Fans (hwmon2 & hwmon3) runs in minimum speed if the CPU temperature below **70** degree C.

MAXTEMP

The temperature over which the fan gets switched to maximum speed.

Fans (hwmon2 & hwmon3) runs in maximum speed if the CPU temperature above **90** degree C.

MINPWM

The PWM value to use when the temperature is below MINTEMP. Typically, this will be either 0 if it is OK for the fan to plain stop, or the same value as MINSTOP if you don't want the fan to ever stop. If this value isn't defined, it defaults to 0 (stopped fan).

Set minimum PWM value to **0**. On Type-C fan, it would stopped the fan while on Type-A fan it would run in minimal speed.


!!! note
    The Helios4 fancontrol configuration file can be found [here](https://raw.githubusercontent.com/armbian/build/master/packages/bsp/helios4/fancontrol_pwm-fan-mvebu-next.conf).

### Thermal Zone on Device Tree

As an alternative to userspace tool like [fancontrol](#fancontrol-automated-software-based-fan-speed-control), Linux Kernel provides Thermal Framework to do thermal management.

Below is an example of device tree nodes that can be added to Helios4 device tree to make use of Linux Thermal Framework.

!!! note
    Currently *armada_thermal* driver ([CPU Thermal Sensor](#cpu-thermal-sensor)) does not support thermal-zone binding in device tree, therefore it can not be used as thermal-sensor yet.

```
/ {
   ...

	fan1: j10-pwm {
		compatible = "pwm-fan";
		pwms = <&gpio1 9 40000>;	/* Target freq:25 kHz */
		cooling-min-state = <0>;
		cooling-max-state = <3>;
		#cooling-cells = <2>;
		cooling-levels = <0 25 128 255>;
	};

	fan2: j17-pwm {
		compatible = "pwm-fan";
		pwms = <&gpio1 23 40000>;	/* Target freq:25 kHz */
		cooling-min-state = <0>;
		cooling-max-state = <3>;
		#cooling-cells = <2>;
		cooling-levels = <0 25 128 255>;
	};

	thermal-zones {
		microsom_thermal: microsom-thermal {
			thermal-sensors = <&thermal>;
			polling-delay-passive = <250>; /* milliseconds */
			polling-delay = <500>; /* milliseconds */
			trips {
				cpu_active: cpu_active {
					/* millicelsius */
					temperature = <70000>;
					hysteresis = <2000>;
					type = "active";
				};

				cpu_alert: cpu_alert {
					/* millicelsius */
					temperature = <90000>;
					hysteresis = <2000>;
					type = "hot";
				};

				cpu_crit: cpu-crit {
					/* millicelsius */
					temperature = <115000>;
					hysteresis = <5000>;
					type = "critical";
				};
			};
		};

		board_thermal: board-thermal {
			thermal-sensors = <&temp_sensor>;
			polling-delay-passive = <0>; /* milliseconds */
			polling-delay = <1500>; /* milliseconds */
			trips {
				board_active: board-active {
					/* millicelsius */
					temperature = <40000>;
					hysteresis = <2000>;
					type = "active";
				};

				board_alert: board-alert {
					/* millicelsius */
					temperature = <60000>;
					hysteresis = <2000>;
					type = "hot";
				};

				board_critical: board-critical {
					/* millicelsius */
					temperature = <70000>;
					hysteresis = <2000>;
					type = "critical";
				};
			};

			cooling-maps {
				map0 {
					trip = <&board_active>;
					cooling-device = <&fan1 THERMAL_NO_LIMIT 2>,
							 <&fan2 THERMAL_NO_LIMIT 2>;
				};
				map1 {
					trip = <&board_alert>;
					cooling-device = <&fan1 2 THERMAL_NO_LIMIT>,
							 <&fan2 2 THERMAL_NO_LIMIT>;
				};
			};
		};
	};
    ...
};

&temp_sensor {
	#thermal-sensor-cells = <0>;
};
```

## References

[Pulse-width modulation](https://en.wikipedia.org/wiki/Pulse-width_modulation)

[4-Wire Pulse Width Modulation (PWM) Controlled Fans Specification rev. 1.3](/files/fan/4_Wire_PWM_Spec.pdf)

[fancontrol man page](https://linux.die.net/man/8/fancontrol)

[Linux Thermal Framework Device Tree descriptor](https://www.kernel.org/doc/Documentation/devicetree/bindings/thermal/thermal.txt)
