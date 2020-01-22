disqus:

# Helios64 介绍

Helios64 是一款专门面向网络附加存储 (NAS) 设计的 ARM 架构主板，采用强大的 **Rockchip RK3399(K) SoC** 芯片。

![Helios64](/helios64/img/intro/helios64.png)

Helios64 是我们最新设计的 ARM 架构的 NAS 旗舰。相比 [Helios4](/helios4/intro)，Helios64 实现了全面的提升：

* 存储扩容：增至 5x SATA 端口
* 网络扩容：采用复合千兆网口实现更大的网络吞吐量 (2.5 GbE)
* 内存扩容：采用速度更快容量更大的 4GB LPDDR4 内存
* 更多功能：增加显示接口和直连存储 (DAS) 模式
* 可靠性：内建 UPS 提升设备可靠性

# 配置概览

## 主板

|**主板配置**||
|------------|-----------|
|**SoC**||
|SoC 型号|Rockchip RK3399(K) - 六核<br>2x Cortex-A72 + 4x Cortes-A53 |
|SoC 架构|ARMv8-A 64-bit|
|CPU 频率|A72 : 2.0 GHz<br> A53 : 1.6GHz |
|其他功能|- GPU Mali-T860MP4<br>- 视频编码/解码引擎<br>- 安全加速引擎<br>- Secure Boot|
|**内存**||
|LPDDR4 RAM|4GB|
|eMMC 5.1 NAND 闪存|16GB|
|SPI NOR 闪存|128Mb|
|**HDD/SSD 存储接口**||
|SATA 3.0 |5|
|M.2 SATA 3.0 |1 (通道与 SATA 1 接口共用)|
|最大存储量|80 TB (16 TB x 5)|
|**外部接口**||
|复合千兆网口 (2.5Gbe)|1|
|千兆网口 (1Gbe)|1|
|USB Type-C|1<br>支持模式：<br>- DP 显示模式<br>- DAS 直连模式<br>- 主机模式<br>- 串口控制台
|USB 3.0|3|
|microSD (SDIO 3.0)|1|
|**开发接口**||
|GPIO|20|
|I2C|1|
|UEXT|1|
|**其他**||
|PWM 风扇|2|
|板载硬盘供电|yes|
|内建 UPS|yes|
|RTC 电池|yes|
|DC 输入|双路 12V 输入|

![Helios64 主板正面](/helios64/img/intro/helios64-top-view.jpg)


## 规格


|**设计规格**||
|------------|-----------|
|主板尺寸|120mm x 120mm|
|主板重量|180克 (不含散热器)|
|机箱尺寸 (H x W x D)|H 134mm x W 222mm x D 250mm|
|机箱重量|3.5Kg (不含硬盘)|
|机箱材质|铝 + 铁|

## 软件

|**软件配置**||
|------------|-----------|
|操作系统|Linux Debian 和 Ubuntu|
|Linux 内核版本|5.4
|U-Boot 版本|2019.11
|合作软件|- Armbian: Debian and Ubuntu for ARM board<br>- OpenMediaVault: Linux NAS turn-key solution<br>- Syncloud: Cloud services at your premises<br>- Nextcloud: The File Hosting Solutions|


**信息正在更新.....敬请期待！**

![Helios64 散热器](/helios64/img/intro/helios64-heatsink.jpg)
