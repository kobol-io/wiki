## PWM Introduction

Please kindly review the [pwm pages](/helios4/pwm) from the Helios4 device.
Basically the PWM mechanism of Helios64 board is same with Helios4.

## Fan Control Schematic

![!Fan Control Schematic](img/fan/fan_control_schematic.png)

**Remarks**

| Description | Header P7 | Header P6 | Remarks |
|-----------|---------|-----------|---------|
| PWM pin | PWM0 | PWM1 | 5V tolerant |
| SENSE pin | GPIO4_C5 | GPIO4_C7 | no kernel module/userspace apps that make use of this pin yet  |
| PWM Frequency | 25 kHz | 25 kHz | defined in device tree |

## Fan Specification in Helios64

Coming Soon.

## Use Case in Linux

Coming Soon.

!!! Notes
       RPM readings in the PWM fans is not available in Helios64 board.

