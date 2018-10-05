## Cross compiler

Under Debian / Ubuntu you need first to install the necessary packages and tools for cross compiling for ARM.

```bash
sudo apt-get install gcc make gcc-arm-linux-gnueabi binutils-arm-linux-gnueabi
```

Other option, use Linaro cross compiler 4.9.4 arm-gnueabi toolchain. Download [here](https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabi/).

!!! Note
	DO NOT use hard-float variant (arm-linux-gnueabihf).

## Compile U Boot

```bash
git clone https://github.com/helios-4/u-boot-marvell.git

cd u-boot-marvell

export ARCH=arm
export CROSS_COMPILE="/path/to/cross/compiler"
export CROSS_COMPILE_BH=${CROSS_COMPILE}

make mrproper
```

!!! note
    To compile using Ubuntu 16.04 cross compiler, please apply [this patch](https://github.com/armbian/build/blob/master/patch/u-boot/u-boot-mvebu/tools-bin_hdr-compiler-fixes.patch) to U-Boot source code.

!!! note
    To support Armbian boot script (/boot/boot.src), please apply [this patch](/files/uboot/u-boot-armbian-boot-script-support.patch) to U-Boot source code.


### SD Card image

```
./build.pl -f mmc -b armada_38x_helios4
```

it would produced *u-boot-a38x-**mm**-**d**-mmc.bin* whereas **mm** is month and **d** is day. For example, building u-boot on October 2nd would produced
*u-boot-a38x-10-2-mmc.bin*

### SPI NOR flash image

```
./build.pl -f spi -b armada_38x_helios4
```

it would produced *u-boot-a38x-**mm**-**d**-spi.bin* whereas **mm** is month and **d** is day. For example, building u-boot on October 2nd would produced
*u-boot-a38x-10-2-spi.bin*
