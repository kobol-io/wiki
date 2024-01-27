disqus:

# Helios64 Introduction.

Helios64 is a powerful ARM board specially designed for Network Attached Storage (NAS). It harnesses its processing capabilities from the **Rockchip RK3399 SoC**.

![Helios64](/helios64/img/intro/helios64.png)

Helios64 is our latest design for the ultimate ARM powered NAS. Compared to the [Helios4](/helios4/intro/), it offers improvement on every single key aspect :

* More storage capacity with 5x SATA ports,
* Greater network throughput with Multi-Gigabit Ethernet (2.5 GbE),
* Faster and Larger Memory with 4GB LPDDR4,
* More functionalities with Display Port and DAS modes support,
* Reinforced reliability with Built-in UPS.

## Overall Specifications

### Board

|**Board Specifications**||
|------------|-----------|
|**SoC**||
|SoC Model|Rockchip RK3399 - Hexacore<br>2x Cortex-A72 + 4x Cortex-A53 |
|SoC Architecture|ARMv8-A 64-bit|
|CPU Frequency|A72 : 1.8 GHz<br> A53 : 1.4 GHz |
|Additional Features|- GPU Mali-T860MP4<br>- Video Encode/Decoder Engines<br>- Security Acceleration Engines<br>- Secure Boot|
|**Memory**||
|LPDDR4 RAM|4GB<br>_*ECC option available 2021_|
|eMMC 5.1 NAND Flash|16GB|
|SPI NOR Flash|128Mb|
|**HDD/SSD Interfaces**||
|SATA 3.0 Ports|5|
|M.2 SATA 3.0 Slot|1 (shared with SATA port 1)|
|Max Raw Capacity|80 TB (16 TB drive x 5)|
|**External Interfaces**||
|Multi-Gigabit LAN Port (2.5Gbe)|1|
|Gigabit LAN Port (1Gbe)|1|
|USB Type-C|1<br>Supports following:<br>- DisplayPort Mode<br>- DAS Mode<br>- Host Mode<br>- Serial Console
|USB 3.0|3|
|microSD (SDIO 3.0)|1|
|**Developer Interfaces**||
|GPIO|16|
|I2C|1|
|UEXT|1|
|**Others**||
|PWM FAN|2|
|On-Board HDD Power|yes|
|Built-in UPS|yes|
|RTC Battery|yes|
|DC input|Dual 12V inputs|
|Wake-on-LAN|yes|
|Front Panel Extension|yes|

![Helios64 Top View](/helios64/img/intro/helios64-top-view.jpg)

### Mechanical

|**Mechanical Specifications**||
|------------|-----------|
|Board Dimension|120mm x 120mm|
|Board Weight|180gr (without heatsink)|
|Case Dimension (H x W x D)|H 144mm x W 222mm x D 250mm|
|Case Weight|3.5Kg (without HDD)|
|Case Material|Aluminum + Metal|

### Software

|**Software Specifications**||
|------------|-----------|
|Operating System|Linux Debian and Ubuntu|
|Kernel Version|4.4 and 5.8
|U-Boot Version|2020.07
|Software Partners|- Armbian: Debian and Ubuntu for ARM board<br>- OpenMediaVault: Linux NAS turn-key solution<br>- Syncloud: Cloud services at your premises<br>- Nextcloud: The File Hosting Solutions|

## Where to Start ?

Once you have received your Helios64, this wiki will run you through all the necessary steps to setup your system.

1. [Kit Assembly](/helios64/kit/) - How to put together your Enclosure Kit.

2. [Download](/download/#helios64) - Get the latest OS build to install.

3. [Install](/helios64/install/preliminary/) - 1st startup and set-up instructions.

4. [Hardware](/helios64/hardware/) - Understand Helios64 hardware and take advantage of all its features.

### Support Forum

If you are facing some issues, you can go on [**Armbian**](https://forum.armbian.com) forum to ask for some help.
