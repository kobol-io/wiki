!!! important
    This install procedure only works on **Armbian Buster**

!!! note
    Tested with Linux helios64 5.10.16-rockchip64 / Armbian 21.02.2


This page describes a method to easily build ZFS on your system in case the DKMS install method described [here](/helios64/software/zfs/install-zfs/) fails.

##  **Step 1** - Install Docker

You can easily install docker by using **armbian-config** tool.

*armbian-config -> software -> softy -> docker*

##  **Step 2** - Create Dockerfile

Create dedicated directory with the required Dockerfile

```bash
mkdir zfs-builder
cd zfs-builder
wget https://wiki.kobol.io/helios64/files/zfs/Dockerfile
```

Build docker image for ZFS building purpose.

```bash
sudo docker build --tag zfs-build-ubuntu-bionic:0.1 .
```

##  **Step 3** - Build and install ZFS packages.

```bash
wget https://wiki.kobol.io/helios64/files/zfs/install-zfs.sh
chmod +x install-zfs.sh
./install-zfs.sh
```

On succeed, you may need to reboot and enable services:

```bash
sudo reboot
sudo systemctl enable zfs-import-cache  zsf-import.target  zfs-mount  zfs.target  zfs-zed
```

------------

*Page contributed by [samorodkin](https://github.com/samorodkin)*

*Reference [Armbian Forum Dicussion](https://forum.armbian.com/topic/16119-zfs-on-helios64/)*
