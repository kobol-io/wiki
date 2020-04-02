disqus:

# Helios4 Introduction.

Helios4 is a powerful ARM based board specially designed for Network Attached Storage. It harnesses its processing capabilities from the **ARMADA 38x-MicroSoM** from [SolidRun](https://wiki.solid-run.com/doku.php?id=products:a38x:microsom).

![Helios64](/helios4/img/intro/helios4.jpg)

The **Marvell ARMADA® 388** is a robust and energy-efficient System on Chip (SoC) with a collection of high speed interfaces especially suited for headless data processing, networking and storage. This Dual-core ARM Cortex A9 CPU clocked at 1.6 Ghz, paired with 2GB of ECC memory, integrates a Cryptographic and XOR DMA engines to provide the best level of performance and reliability for NAS functionalities.

## Overall Specifications

|**Board Specifications**||
|------------|-----------|
|**SoC**||
|SoC Model|Marvell Armada 388 (88F6828)<br>ARM Cortex-A9|
|SoC Architecture|ARMv7 32-bit|
|CPU Frequency|Dual Core 1.6 Ghz|
|Additional Features|- RAID Acceleration Engines<br>- Security Acceleration Engines<br>- Wake-on-LAN|
|**Memory**||
|System Memory|2GB DDR3L ECC|
|**HDD/SSD Interfaces**||
|SATA 3.0 Ports|4|
|Max Raw Capacity|48 TB (12 TB drive x 4)|
|Max Single Volume Size|16 TB|
|**External Interfaces**||
|GbE LAN Port|1|
|USB 3.0|2|
|microSD (SDIO 3.0)|1|
|**Developer Interfaces**||
|GPIO|12|
|I2C|1|
|UART|1 (via onboard Micro-USB converter)|
|**Others**||
|Boot Mode Selector|- SPI<br>- SD Card<br>- UART<br>- SATA|
|SPI NOR Flash|32Mbit onboard|
|PWM FAN|2|
|RTC Battery|1|
|DC input|12V / 8A|

|**Mechanical Specifications**||
|------------|-----------|
|Board Dimension|100mm x 100mm|
|Board Weight|120gr|
|Case Dimention (H x W x D)|182 mm x 107 mm x 210 mm|
|Case Weight (without HDD)|450gr|
|Case Material|Colored Acrylic|

|**Software Specifications**||
|------------|-----------|
|Operating System|Linux Debian and Ubuntu|
|Kernel Version|4.14
|U-Boot Version|2018.11
|Software Partners|- Armbian: Debian and Ubuntu for ARM board<br>- OpenMediaVault: Linux NAS turn-key solution<br>- Syncloud: Cloud services at your premises|

## Where to Start ?

Once you have received your Helios4, this wiki will run you through all the necessary steps to setup your system.

1. [Kit Assembly](/helios4/kit) - How to put together your Helios4.

2. [Download](/helios4/download) - Get the latest OS build to install.

3. [Install](/helios4/install) - 1st startup and set-up instructions.

4. [Software](/helios4/omv) - Collection of tutorials on different 3rd party applications.

5. [Hardware](/helios4/hardware) - Understand Helios4 hardware and take advantage of all its features.

### Armbian Support Forum

If you are facing an issue, you can go on the **Armbian** forum to ask for some help. There is a thread dedicated to [Helios4 support](https://forum.armbian.com/topic/6033-helios4-support/).
