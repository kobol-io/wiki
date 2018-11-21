# 欢迎访问 Helios4 Wiki

Helios4 是一款面向网络附加存储（NAS）特别设计的 ARM 主板，搭载功能强大的 [SolidRun](https://wiki.solid-run.com/doku.php?id=products:a38x:microsom) **ARMADA 38x-MicroSoM**
芯片。

<img style="float: right;" src="/img/intro/helios4.jpg">

**Marvell ARMADA® 388** 是一款健壮且节能的芯片系统（SoC），具有一系列高速接口，特别适用于
数据处理、网络和存储应用。它搭载的 ARM 双核 Cortex A9 CPU 主频 1.6 GHz，外加 2GB ECC 内存，
集成了加密和 XOR DMA 引擎，为 NAS 应用提供了最佳性能和可靠性。

Helio4 是一个开源硬件项目，因此我们会在此 wiki 上发布所有项目相关的数据

**除了整合技术数据外，此 Wiki 的作用还在于提供 Helios4 的使用指南。**

## 总体规格

**主板规格**||
---|---
CPU 型号|Marvell Armada 388 (88F6828)<br>ARM Cortex-A9
CPU 架构|ARMv7 32-bit
CPU 频率|双核 1.6 Ghz
附加功能|- RAID 加速引擎<br>- 安全加速引擎<br>- Wake-on-LAN
系统内存|2GB DDR3L ECC
SATA 3.0 |4
最大存储容量|48 TB (12 TB drive x 4)
千兆网卡|1
USB 3.0|2
microSD (SDIO 3.0)|1
GPIO|12
I2C|1
UART|1 (通过板载 micro-USB 接口转换)
启动模式选择|- SPI<br>- SD 卡<br>- UART<br>- SATA
SPI NOR Flash|板载 32Mbit
PWM 风扇|2
DC 电源|12V / 8A
