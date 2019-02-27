
![Ethernet PHY](/img/wol/schematic.png)

The ARMADA 388 provides several waking options sourced by different peripherals to take the system out of power save modes. Some of the options are

* Wake on GPIO

* Wake on LAN

Currently Helios4 use PHY interrupt and Wake on GPIO event to implement Wake on LAN.

## Device Tree Support

Linux provides gpio-keys driver to handle GPIO event and can be configured as wakeup source.

```
	gpio-keys {
		compatible = "gpio-keys";
		pinctrl-0 = <&microsom_phy0_int_pins>;

		wol {
			label = "Wake-On-LAN";
			linux,code = <KEY_WAKEUP>;
			gpios = <&gpio0 18 GPIO_ACTIVE_LOW>;
			wakeup-source;
		};
	};
```

Device Tree Patch can be found [here](/files/wol/helios4-dts-add-wake-on-lan-support.patch)

## Kernel Patch

Current gpio-mvebu driver does not implement [irq_set_wake()](https://www.kernel.org/doc/html/v4.14/core-api/genericirq.html?highlight=irq_set_wake#c.irq_chip)
to support GPIO as wakeup source and properly route it to upper interrupt controller (Arm GIC).

This will raise following issues:

- System unable to wake up from Suspend-to-RAM

- Kernel crash during wakeup from standby

```
[   59.169436] ------------[ cut here ]------------
[   59.174075] WARNING: CPU: 0 PID: 1535 at kernel/irq/manage.c:623 irq_set_irq_wake+0xe4/0x11c
[   59.182533] Unbalanced IRQ 50 wake disable
[   59.186638] Modules linked in: lz4hc lz4hc_compress marvell_cesa zram zsmalloc lm75 pwm_fan ip_tables x_tables
[   59.196690] CPU: 0 PID: 1535 Comm: bash Not tainted 4.14.94-mvebu+ #14
[   59.203234] Hardware name: Marvell Armada 380/385 (Device Tree)
[   59.209183] [<c01118d0>] (unwind_backtrace) from [<c010c7cc>] (show_stack+0x10/0x14)
[   59.216955] [<c010c7cc>] (show_stack) from [<c095091c>] (dump_stack+0x88/0x9c)
[   59.224204] [<c095091c>] (dump_stack) from [<c012ab9c>] (__warn+0xe8/0x100)
[   59.231188] [<c012ab9c>] (__warn) from [<c012abfc>] (warn_slowpath_fmt+0x48/0x6c)
[   59.238696] [<c012abfc>] (warn_slowpath_fmt) from [<c017bb64>] (irq_set_irq_wake+0xe4/0x11c)
[   59.247160] [<c017bb64>] (irq_set_irq_wake) from [<c0747594>] (gpio_keys_resume+0xb0/0x11c)
[   59.255537] [<c0747594>] (gpio_keys_resume) from [<c0654b34>] (dpm_run_callback+0x54/0xec)
[   59.263826] [<c0654b34>] (dpm_run_callback) from [<c0655180>] (device_resume+0xcc/0x270)
[   59.271941] [<c0655180>] (device_resume) from [<c0656660>] (dpm_resume+0x100/0x230)
[   59.279621] [<c0656660>] (dpm_resume) from [<c06569e4>] (dpm_resume_end+0xc/0x18)
[   59.287128] [<c06569e4>] (dpm_resume_end) from [<c0175af8>] (suspend_devices_and_enter+0x210/0x5e0)
[   59.296202] [<c0175af8>] (suspend_devices_and_enter) from [<c01761c0>] (pm_suspend+0x2f8/0x380)
[   59.304927] [<c01761c0>] (pm_suspend) from [<c0174a30>] (state_store+0x70/0xcc)
[   59.312260] [<c0174a30>] (state_store) from [<c02c80e4>] (kernfs_fop_write+0xe8/0x1c4)
[   59.320204] [<c02c80e4>] (kernfs_fop_write) from [<c024ce78>] (vfs_write+0xa4/0x1b4)
[   59.327972] [<c024ce78>] (vfs_write) from [<c024d0b4>] (SyS_write+0x4c/0xac)
[   59.335045] [<c024d0b4>] (SyS_write) from [<c0108620>] (ret_fast_syscall+0x0/0x54)
[   59.342633] ---[ end trace c725de247edb5ce9 ]---
[   59.474369] ata2: SATA link down (SStatus 0 SControl 300)
[   59.474443] ata3: SATA link down (SStatus 0 SControl 300)
[   59.638619] ata1: SATA link down (SStatus 0 SControl 300)
[   59.647170] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   60.081905] ata1: SATA link down (SStatus 0 SControl 300)
[   60.087343] ata1: limiting SATA link speed to 1.5 Gbps
[   60.386518] mvneta f1070000.ethernet eth0: Link is Down
[   60.578411] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   61.162892] ata4.00: configured for UDMA/100
[   62.431232] mvneta f1070000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
[   63.087435] ata1.00: configured for UDMA/100
[   63.159889] OOM killer enabled.
[   63.164643] Restarting tasks ... done.
[   63.181059] PM: suspend exit
```

- System can wake up from any GPIO interrupt without need to define as wakeup source

To fix the issue, gpio-mvebu driver needs to be patched to implement [irq_set_wake()](https://www.kernel.org/doc/html/v4.14/core-api/genericirq.html?highlight=irq_set_wake#c.irq_chip)
and only enable interrupt on GPIO defined as wakeup source.

Patch for Linux Kernel 4.14.x can be found [here](/files/wol/lk4.14-mvebu-gpio-add_wake_on_gpio_support.patch)


## Enabling WoL

Enable the PHY to only raise interrupt when magic packet received then enter suspend mode with these commands:


```
sudo ethtool -s eth0 wol g
sudo systemctl suspend
```

Both command has to be executed to enter suspend mode otherwise there is a risk that Helios4 will not wake up on magic packet received event.
More explaination regarding this issue on next section.

## Limitation with Current Approach

PHY INT pin supposed to be handled by the Ethernet controller so when there is an interrupt the driver can respond and acknowledge the interrupt.
Without this acknowledgement, the PHY INT pin will stay active and the PHY will not trigger another interrupt.

On specific case that after user enabled the wol and magic packet received before entering suspend mode, Helios4 will not able to wake up. 
The reason is PHY interrupt already triggered before entering suspend mode and no other interrupt triggered during suspend mode.
The Ethernet controller driver will reset PHY interrupt during resume and when enabling wol.
Therefore it is advised to always set wol (**sudo ethtool -s eth0 wol g**) before entering suspend.

## Power Consumption

Measured using Sonoff POW R2 on AC side

| Power state   | Power (Watt)  | Current (Ampere) | Remarks |
|---------------|---------------|------------------|---------|
|  Idle         | 16.18 - 19.87 | 0.14 - 0.17      | |
|  Standby      |  8.24 -  8.63 | 0.09 - 0.10      | |
|  Suspend      |  7.46 -  7.71 | 0.07 - 0.08      | |
| Halt/Shutdown | 11.95         | 0.11             | HDDs still active, fans run on full speed |

!!! note
    * Nominal Input Voltage: 220V
    * HDD: 4x WD Red 2TB (WD20EFRX)
    * [I2C OLED screen](/i2c/) attached to the systems
    * Variation of power consumption sometimes due to fluctutation of the input voltage

## Thermal Issue

Using [Batch 2 fan](/pwm/#new-fan-batch-2)

| Power state   | Temperature (°C) | Remarks |
|---------------|------------------|---------|
|  Standby      |  89 - 90 | Fan stopped |
|  Suspend      |  81 - 87 | Fan stopped |

Using [Batch 1 fan](/pwm/#old-fan-batch-1)

| Power state   | Temperature (°C) | Remarks |
|---------------|------------------|---------|
|  Standby      |  -  | Not yet tested |
|  Suspend      |  74 -76 | Fan run in minimum speed |

