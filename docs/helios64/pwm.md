## PWM Introduction

PWM, or pulse width modulation is a technique which allows us to adjust the average value of the voltage that’s going to the electronic device by varying duty cycle of the power at a fast rate.

The term *duty cycle* describes the proportion of 'on' time to the regular interval or 'period' of time; a low duty cycle corresponds to low power, because the power is off for most of the time. Duty cycle is expressed in percent, 100% being fully on. When a digital signal is on half of the time and off the other half of the time, the digital signal has a duty cycle of 50% and resembles a "square" wave. When a digital signal spends more time in the on state than the off state, it has a duty cycle of >50%. When a digital signal spends more time in the off state than the on state, it has a duty cycle of <50%. Here is a pictorial that illustrates these three scenarios:

![PWM duty cycle](/helios64/img/pwm/pwm_duty_cycle_graph.png)

## PWM Fan Implementation

### Type-A

![Type A Curve](/helios64/img/pwm/fan_type_a_curve.jpg)

### Type-B

![Type B Curve](/helios64/img/pwm/fan_type_b_curve.jpg)

### Type-C

![Type C Curve](/helios64/img/pwm/fan_type_c_curve.jpg)


## PWM Fan Schematic

![!Fan Control Schematic](img/pwm/fan_control_schematic.png)

**Remarks**

| Description | Header P7 | Header P6 | Remarks |
|-----------|---------|-----------|---------|
| PWM pin | PWM0 | PWM1 | 5V tolerant |
| SENSE pin | GPIO4_C5 | GPIO4_C7 | no kernel module/userspace apps that make use of this pin yet  |
| PWM Frequency | 25 kHz | 25 kHz | defined in device tree |

## PWM Fan Connector

![Fan Connector](/helios4/img/pwm/fan_connector.png)

Connector Pinout

| Pin | Function | Wire Color |
|-----|----------|------------|
|  1  |    GND   |   Black    |
|  2  |    12V   |   Red      |
|  3  |   Sense  |   Yellow   |
|  4  |  Control |   Blue     |
