These instructions document how FreeBSD (head) can be built for, and installed on the Helios-4. This has been made possible by the initial port of FreeBSD to the SolidRun Clearfog that has been submitted June 2017 by Semihalf and Stormshield: [Read the announcement here](https://lists.freebsd.org/pipermail/freebsd-arm/2017-June/016314.html).

## Compiling FreeBSD
There is a manual way to compile FreeBSD, and it is documented on the [SolidRun Wiki Clearfog page](https://wiki.solid-run.com/doku.php?id=products:a38x:software:os:freebsd). The process is almost identical for the Helios-4 in that a suitable DTB has to be copied to the boot partition.
The following instructions use the [crochet](https://github.com/FreeBSD/crochet/) utility for automating the build and imaging process.

### Get the source
We use a fork of crochet that has added the necessary bits for Helios-4.
```bash
mkdir work; cd work
git clone --checkout pr-clearfog https://github.com/Artox/crochet.git
svn checkout https://svn.freebsd.org/base/head src
```

### Configure the build
crochet uses a configuration file to perform builds. config.sh.sample is an example, and can be adapted as needed. As a bare minimum, a line
```bash
board_setup Clearfog
```
has to be at the top near the other commented board_setup_* lines.
In addition enabling the growfs feature has proven useful for autoresizing the rootfs on first boot: simply uncomment the line
```bash
option Growfs
```

There are plenty of other settings to change, but these suffice for creating a bootable image.

### Build
Navigate to the crochet folder, and assuming you called your config file config.sh, run:
```bash
sudo /bin/sh crochet.sh -c config.sh
```
On success an sdcard image will have been produced in the build directory, for example */opt/work/build/FreeBSD-armv7-12.0-GENERIC-333641-Clearfog.img*.
This image is a complete FreeBSD installation, without U-Boot installed.

### Create SD-Card
The previously created image can be written to an sdcard as is; assuming your SD-Card is available at /dev/sdX, write the image to it:
```bash
pv FreeBSD-armv7-12.0-GENERIC-333641-Clearfog.img | sudo tee /dev/sdX >/dev/null
```

## Boot It
In an ideal world U-Boot would already be installed in SPI flash, including the necessary patch for FreeBSD. If you happen to have such an ideal system, you may skip the next section

### Install U-Boot
Please refer to [U-boot](/helios4/uboot) for build instructions.

The Boot-ROM expects to find U-Boot at 512 bytes into the sdcard. Assuming your SD-Card is available at /dev/sdX, write the u-boot binary to it using dd:
```bash
sudo dd bs=512 seek=1 conv=fsync if=u-boot-a38x-5-15-mmc.bin of=/dev/sdX
```

### Boot
Insert the sd-card into your device, connect a serial console and turn it on.
The U-Boot console will come up with a prompt:
```bash
Hit any key to stop autoboot: 3
```
Press a key to abort automatic boot, or wait till it fails to do a network boot.
Once it has dropped to a terminal prompt, indicated by *Marvell>>* at the start of the line, configure U-Boot to load the FreeBSD loader by default:
```bash
setenv fdt_addr_r 0x1000000
setenv loadaddr 0x2000000
setenv bootcmd 'fatload mmc 0:2 ${fdt_addr_r} armada-388-helios4.dtb; fatload mmc 0:2 ${loadaddr} ubldr.bin; go ${loadaddr}'
setenv bootdelay 1
saveenv
```
Beware: You probably have to paste these lines individually, or U-Boot may mess it up. You can set bootdelay to 0 if you want, that way you will never again get to the u-boot console unless you delete the FreeBSD loader.

Finally, type *boot*, or *reset*, or reset the board by pressing the button labeled U16 on the board.
This time, just sit back and watch as FreeBSD comes up.

### Default User
The FreeBSD image by crochet comes with an unlocked root account. This means you do not need to enter a password to log in as root.

*Page contributed by [Artox](https://github.com/Artox)*
