RK3399 has 6x SPI controllers with the following features:

- Support master and slave mode, software-configurable
- DMA-based or interrupt-based operation
- Embedded two 32x16bits FIFO for TX and RX operation respectively

On Helios64, the buses are divided into three types: *Not Available*, *System* (internal bus) and *User* (external bus).

| Bus | Usage |  Remarks |
|-----|-------|-----------|
| 0 | Not Available | |
| 1 | System | Bootable SPI Flash |
| 2 | User | User Application |
| 3 | Not Available | |
| 4 | Not Available | |
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

- Preloader & bootloader

| Binaries | Offset | Remarks |
|----------|--------|---------|
| Preloader | 0x0040 | U-Boot TPL & SPL |
| Bootloader | 0x4000 | U-Boot & ATF |

- Electronic nameplate data in Security Register

## External Bus

| Bus | Chip Select | Remarks |
|-----|-------------|---------|
|  2  | 0 | User Application |

SPI Bus for user application is exposed on [UEXT header (P2)](/helios64/uext)

![P2 Location](/helios64/img/spi/uext.jpg)

![!UEXT](/helios64/img/spi/spi_on_uext.png)

| Pin | Signal Name |
|-----|-------------|
| 7 | MISO |
| 8 | MOSI |
| 9 | SCK |
| 10 | SSEL |

**Note:** The pin voltage level is 3.3V.
