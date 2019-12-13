This document is a guide for installing Arch Linux ARM on the Helios4.

**Arch Linux ARM** is a port of Arch Linux for ARM processors. Its design philosophy is simplicity and full control to the end user, and like its parent operating system Arch Linux, aims to be very Unix-like. More info [here](https://archlinuxarm.org/).

## Prerequisite

Refer to the following [section](/helios4/install/#what-you-need-before-you-start) of the Helios4 install guide.

## Arch Linux ARM image for Helios4

Arch Linux ARM can be installed on Helios4 using an image file containing both the **Arch Linux ARM system** and the **U-Boot** boot loader.

This image can be created using the `build-archlinux-img-for-helios4.sh` script provided by the [alarm-helios4-image-builder](https://github.com/gbcreation/alarm-helios4-image-builder) project, or you can use pre-built images provided by the same project. Each method is described below.

Once you get an image file, follow the instructions from the [Installing Arch Linux ARM on Helios4](#installing-arch-linux-arm-on-helios4) section below.

### Arch Linux ARM image builder

The `build-archlinux-img-for-helios4.sh` script provides an easy way to automatically create a bootable Arch Linux ARM image file for Helios4.

#### Requirements

The `build-archlinux-img-for-helios4.sh` script expects to be run on a **x86 system running [Arch Linux](https://archlinux.org)**. It needs `qemu-arm-static` to work. You can install it using the [qemu-user-static](https://aur.archlinux.org/packages/qemu-user-static/) or [qemu-user-static-bin](https://aur.archlinux.org/packages/qemu-user-static-bin/) packages from the AUR.

#### Usage

!!! note
    This script needs to execute commands as superuser. If not run as root, it will re-run itself using sudo.

```shell
$ git clone https://github.com/gbcreation/alarm-helios4-image-builder.git
$ cd alarm-helios4-image-builder
$ sh ./build-archlinux-img-for-helios4.sh
```

Once the Arch Linux ARM image is created, go to [Installing Arch Linux ARM on Helios4](#installing-arch-linux-arm-on-helios4) section.

### Pre-built images

You can download [here](https://github.com/gbcreation/alarm-helios4-image-builder/releases) pre-built Arch Linux ARM images for Helios4.

```shell
$ wget https://github.com/gbcreation/alarm-helios4-image-builder/releases/download/2019-02-27/ArchLinuxARM-helios4-2019-02-27.img.gz{,.md5}
$ md5sum -c ArchLinuxARM-helios4-2019-02-27.img.gz.md5
$ gunzip ArchLinuxARM-helios4-2019-02-27.img.gz
```

## Installing Arch Linux ARM on Helios4

Once you get an Arch Linux ARM image, follows these instructions to use it on Helios4:

### Writing image / power-up Helios4 / connecting to serial console

Follows these steps from the Helios4 [install guide](/helios4/install):

- [step 2](/helios4/install/#step-2-writing-an-image-to-a-microsd-card) to write the Arch Linux ARM image to a microSD card
- [step 3](/helios4/install/#step-3-power-up-helios4) to power-up Helios4
- [step 4](/helios4/install/#step-4-connect-to-helios4-serial-console) to connect to the Helios4 serial console.

!!! note
    Arch Linux ARM is configured by default to get its IP address from a DHCP server. As an alternative to **step 4**, you can connect to your router to find the IP address given to Helios4, then connect to this latter using SSH.

### Log in

Use the serial console or SSH to the IP address given to Helios4 by your router.

You can login as:

- the default user *alarm* with the password *alarm*
- the user *root* with password *root*

!!! important
    For security reasons, it is highly recommended to change the default password of the **alarm** and **root** users.

### Network settings

Arch Linux ARM is configured by default to get its IP address from a DHCP server. To change the network settings, look at the [Network Configuration](https://wiki.archlinux.org/index.php/Network_configuration) page from the Arch Linux wiki.

### Pacman

The Pacman keyring is already initialized in the images created by the `build-archlinux-img-for-helios4.sh` script and the pre-built images. It is also already populated with the Arch Linux ARM package signing keys.

## What to do next?

You can now configure Arch Linux ARM according to your needs and use **pacman** to install 3rd party applications.

Here are some useful links from the [Arch Linux wiki](https://wiki.archlinux.org) to get started:

- [RAID](https://wiki.archlinux.org/index.php/RAID)
- [dm-crypt/Device encryption](https://wiki.archlinux.org/index.php/Dm-crypt/Device_encryption).

!!! note
    Read the [Disk Encryption Acceleration](/helios4/cesa/#disk-encryption-acceleration) section of the Helios4 wiki before proceeding to learn how to offload disk encryption on the CESA unit.

- [Nextcloud](https://wiki.archlinux.org/index.php/Nextcloud)
- [NFS](https://wiki.archlinux.org/index.php/NFS)
- [Samba](https://wiki.archlinux.org/index.php/Samba)


*Page contributed by [gbcreation](https://github.com/gbcreation)*
