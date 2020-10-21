# On-board Button

![Button Location](img/button/button.jpg)

!!! note
    All the above on-board buttons are also exposed on the [Front Panel](/helios64/front-panel/).

## Power Button

Helios64 board provides a POWER push button (SW1) to power ON/OFF the system. This button is connected to Power Management IC (PMIC) RK808-D. The following actions can be performed:

* **Power ON** : Short press (~1 second) will turn on the system when the current state is power off.
* **Power OFF** : Short press (~1 second) will inform system to perform graceful shutdown when the system is on.
* **Force Power OFF** : Long press (~4 seconds) will signals PMIC to cut off the power in case of system not responding.

## Reset Button

Helios64 board provides a RESET push button (SW3) to hard reset the system.

## Recovery Button

Helios64 board provides a RECOVERY push button (SW2) to allow user to easily flash over USB the on-board eMMC storage. This can be useful if you want to do a fresh install or if you want to repair a system that doesn't boot anymore.

User can enter recovery mode by pressing this button during boot up (bootloader stage). U-Boot will read the button state and switch the USB type-C port into USB Mass Storage device to expose eMMC flash as storage device (UMS mode).

!!! note
    Recovery mode is only supported since Armbian version 20.08.13. You need to have U-Boot installed either on microSD card or on eMMC. Refer to fresh install [section](/helios64/install/preliminary/#install-options) if you haven't setup your system yet.

**Quick Instructions :**

1. Press and hold Recovery Button during power-up until System Status LED blinks 1 time. System should enter UMS mode and your computer should have detected a new storage device called _Linux UMS disk 0_.

2. User can then use flash tools to write new OS image into eMMC flash. Refer to this [section](/helios64/install/emmc/#step-5-writing-an-os-image-to-internal-emmc).

User can also enter into *maskrom* mode in order to use some of the Rockchip programming tools (e.g [rkdeveloptool](https://github.com/rockchip-linux/rkdeveloptool)). For this, you will need first to enable [Jumper 13](/helios64/jumper/#usb-consolerecovery-mode-p13). To enter *markrom* mode, press and hold Recovery Button during power-up until System Status LED blinks 2 times. Refer to [Maskrom page](/helios64/maskrom/)

Under Linux, this button behaves as user button and when pressed will emit **BTN_0** keycode (refer to [Linux Input Codes](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/include/uapi/linux/input-event-codes.h)). Therefore this button can also be used to trigger other actions than recovery.
