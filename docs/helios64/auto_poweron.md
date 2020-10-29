Helios64 automatic power-on circuitry when main power applied to the system so user does not need to press power button.
This is useful in case of loss of main power longer than UPS back up time. The system will automatically power on when main power returns.

![!Auto power-on State](/helios64/img/auto-poweron/flowchart.png)

U-Boot will enable Auto Power-On and a [systemd-shutdown](https://www.freedesktop.org/software/systemd/man/systemd-shutdown.html) hook script to disable the Auto Power-On during graceful shutdown.


By default the system needs the user to press power button to power up. This behavior can be changed by manipulating a set of GPIOs.
The circuitry uses [D Flip Flop](https://en.wikipedia.org/wiki/Flip-flop_(electronics)#D_flip-flop) and relies on RTC battery or UPS battery to keep the state.

![!Auto Power-On Schematic](/helios64/img/auto-poweron/schematic_flip_flop.png)

|  State  | D     | Clock    |
|---------|-------|-------------|
| Enable  | 1     | Rising edge |
| Disable | 0     | Rising edge |


## Auto Power-On Control

*AUTO_ON_EN_D* pin and *AUTO_ON_EN_CLK* pin is assigned to gpio **153** and gpio **154** respectively.
After exporting and configure the GPIOs as output (refer to [GPIO Control](/helios64/gpio/#gpio-control)), we will do bit-banging to configure the D Flip Flop.

To enable the Auto Power-On

```
echo 1 > /sys/class/gpio/gpio153/value
echo 0 > /sys/class/gpio/gpio154/value
sleep 0.1
echo 1 > /sys/class/gpio/gpio154/value
sleep 0.1
echo 0 > /sys/class/gpio/gpio154/value
```

To disable the Auto Power-On

```
echo 0 > /sys/class/gpio/gpio153/value
echo 0 > /sys/class/gpio/gpio154/value
sleep 0.1
echo 1 > /sys/class/gpio/gpio154/value
sleep 0.1
echo 0 > /sys/class/gpio/gpio154/value
```

## Systemd-shutdown Script

We put a script to disable Auto Power-On during shutdown, located on :

`/lib/systemd/system-shutdown/disable_auto_poweron`

The script content:

```bash
#!/bin/bash

# Export GPIO
# AUTO_ON_D
echo 153 > /sys/class/gpio/export
# AUTO_EN_CLK
echo 154 > /sys/class/gpio/export

echo out > /sys/class/gpio/gpio153/direction
echo out > /sys/class/gpio/gpio154/direction

# Toggling the D Flip-Flop
echo 0 > /sys/class/gpio/gpio153/value
echo 0 > /sys/class/gpio/gpio154/value
sleep 0.1
echo 1 > /sys/class/gpio/gpio154/value
sleep 0.1
echo 0 > /sys/class/gpio/gpio154/value
```

!!! Info
    Current implementation does not check whether there is loss of power event.
