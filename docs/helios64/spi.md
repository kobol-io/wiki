!!! notice
	***Preliminary Info***

RK3399 has SPI controller with following features:

- 6 on-chip SPI controllers

- Support master and slave mode, software-configurable

- DMA-based or interrupt-based operation

- Embedded two 32x16bits FIFO for TX and RX operation respectively

On Helios64 the bus are divided into three types: unused, system (internal bus) and user application (external)

| Bus | Usage |  Remarks |
|-----|-------|-----------|
| 0 | Not Used | |
| 1 | System | Bootable SPI Flash |
| 2 | External | User Application |
| 3 | Not Used | |
| 4 | Not Used | |
| 5 | System | Reserved for Production use only |


## Internal Bus

| Bus | Chip Select |  Device | Remarks |
|-----|-------------|---------|---------|
|  1  | 0 | W25Q128JV | Bootable SPI Flash |
|  5  | 0 | W25X20CL | SATA Controller ROM |


### Bootable SPI Flash

Helios64 is equipped with [Winbond W25Q128JV 3V 128M-Bit Serial Flash Memory](https://www.winbond.com/hq/product/code-storage-flash-memory/serial-nor-flash/?__locale=en&partNo=W25Q128JV)
as a Bootable SPI NOR Flash.

This flash contains

- preloader & bootloader

| Binaries | Offset | Remarks |
|----------|--------|---------|
| Preloader | 0x0040 | U-Boot TPL & SPL |
| Bootloader | 0x4000 | U-Boot & ATF |

- electronic nameplate data in Security Register


## External Bus

| Bus | Chip Select | Remarks |
|-----|-------------|---------|
|  2  | 0 | User Application |

SPI Bus for user application is exposed on [UEXT Connector (P2)](/helios64/uext)

![!UEXT](/helios64/img/spi/spi_on_uext.png)

| Pin | Signal Name |
|-----|-------------|
| 7 | MISO |
| 8 | MOSI |
| 9 | SCK |
| 10 | SSEL |

The pin voltage level is 3.3V


## Usage in Linux

### Enable SPIDEV in device tree

To make SPI device accessible by user space application, we need to create a device tree node.
After the node has been created, user application can access the device at

`/dev/spidev5.0`

!!! note
	*To Be Updated*


