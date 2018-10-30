## U-Boot 2018

Based on mainline U-Boot.

### Dependencies

- bison (YACC-compatible parser generator)
- flex (fast lexical analyzer generator)
- bc (GNU bc arbitrary precision calculator language)
- openssl/bn.h header (Secure Sockets Layer toolkit - development files)
- make (GNU Make)
- gcc (GNU C Compiler)

Under Debian / Ubuntu, the dependencies can be installed using

```bash
sudo apt-get -y install bison flex bc libssl-dev make gcc
```


### Cross compiler

Even though mainline U-Boot requires GCC minimum version 6, it would generate oversized SPL (Secondary Program Loader) image. Therefore it is recommended to use GCC version 7.

#### Ubuntu 18.04 LTS

Install the toolchain.

```bash
sudo apt -y install gcc-arm-linux-gnueabihf binutils-arm-linux-gnueabihf
```

Setup environment for cross compiling.
```bash
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
```

#### Other OS/ Distribution

Other OS / Distribution that does not have GCC version 7 such as Debian, should use Linaro arm-linux-gnueabihf toolchain.

Download and extract the toolchain.

```bash
cd ~

wget http://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/arm-linux-gnueabihf/gcc-linaro-7.3.1-2018.05-x86_64_arm-linux-gnueabihf.tar.xz

tar Jxf gcc-linaro-7.3.1-2018.05-x86_64_arm-linux-gnueabihf.tar.xz

```

!!! note
    Latest Linaro toolchain version 7 can be found [here](http://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabihf/).

Setup environment for cross compiling.
```bash
export ARCH=arm
export CROSS_COMPILE=~/gcc-linaro-7.3.1-2018.05-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
```


### Compile U-Boot

```bash
git clone https://github.com/helios-4/u-boot.git -b helios4

cd u-boot

make mrproper
make helios4_defconfig
```

!!! note
    To support Armbian boot script (/boot/boot.scr), please apply [this patch](/files/uboot/u-boot-mainline-armbian-boot-script-support.patch) to U-Boot source code before
    
    *make helios4_defconfig*

#### SD Card image

```bash
make -j$(nproc)
```

it would produced **u-boot-spl.kwb** 

#### SPI NOR flash image

Since *helios4_defconfig* targeting SD card image, we need to modified the configuration to generate SPI NOR flash image before compiling.

```bash
mv -f .config .config_mmc

awk '{\
gsub(/CONFIG_MVEBU_SPL_BOOT_DEVICE_MMC=y/,"# CONFIG_MVEBU_SPL_BOOT_DEVICE_MMC is not set");\
gsub(/# CONFIG_MVEBU_SPL_BOOT_DEVICE_SPI is not set/,"CONFIG_MVEBU_SPL_BOOT_DEVICE_SPI=y");\
gsub(/CONFIG_ENV_IS_IN_MMC=y/,"# CONFIG_ENV_IS_IN_MMC is not set");\
gsub(/# CONFIG_ENV_IS_IN_SPI_FLASH is not set/,"CONFIG_ENV_IS_IN_SPI_FLASH=y");\
}1' .config_mmc >> .config

rm -f .config_mmc

make -j$(nproc)
```

it would produced **u-boot-spl.kwb**


### Customize U-Boot

U-Boot has configuration editor based on ncurses similar like Linux Kernel configuration editor.

Install ncurses development files. Under Debian/Ubuntu can be done using this command

```bash
sudo apt-get -y install libncurses5-dev
```

Launch configuration editor

```bash
make menuconfig
```

![menuconfig main](/img/u-boot/u-boot_menuconfig_main.png)

After exiting the configuration editor and saving the configuration, build the image according to [SD Card image](#sd-card-image) or [SPI NOR flash image](#spi-nor-flash-image) instructions.


- - -

## Marvell U-Boot 2013.01

Based on U-Boot 2013.01 Marvell version: 2015_T1.0p16

### Cross compiler

Under Debian / Ubuntu you need first to install the necessary packages and tools for cross compiling for ARM.

```bash
sudo apt-get install gcc make gcc-arm-linux-gnueabi binutils-arm-linux-gnueabi
```

Other option, use Linaro cross compiler 4.9.4 arm-gnueabi toolchain. Download [here](https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabi/).

!!! Note
	DO NOT use hard-float variant (arm-linux-gnueabihf).

### Compile U-Boot

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
    To support Armbian boot script (/boot/boot.scr), please apply [this patch](/files/uboot/u-boot-armbian-boot-script-support.patch) to U-Boot source code.


#### SD Card image

```
./build.pl -f mmc -b armada_38x_helios4
```

it would produced *u-boot-a38x-**mm**-**d**-mmc.bin* whereas **mm** is month and **d** is day. For example, building u-boot on October 2nd would produced
*u-boot-a38x-10-2-mmc.bin*

#### SPI NOR flash image

```
./build.pl -f spi -b armada_38x_helios4
```

it would produced *u-boot-a38x-**mm**-**d**-spi.bin* whereas **mm** is month and **d** is day. For example, building u-boot on October 2nd would produced
*u-boot-a38x-10-2-spi.bin*
