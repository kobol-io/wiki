!!! Important    This install procedure only works with *Armbian Buster* !!!

Original forum post by @Grek https://forum.armbian.com/topic/16119-zfs-on-helios64/

Tested with Linux helios64 5.10.16-rockchip64 #21.02.2 SMP PREEMPT Sun Feb 14 21:35:01 CET 2021 aarch64 GNU/Linux

First we need to have docker installed ( armbian-config -> software -> softy -> docker )

Create dedicated directory with Dockerfile ( we will customize ubuntu:bionic image with required libraries and gcc 10 . in next builds we can skip this step and just customize and run [install-zfs-buster.sh] (https://raw.githubusercontent.com/kobol-io/wiki/master/docs/helios64/software/zfs/install-zfs-buster/install-zfs-buster.sh) script) 

```bash
mkdir zfs-builder
cd zfs-builder
wget https://raw.githubusercontent.com/kobol-io/wiki/master/docs/helios64/software/zfs/install-zfs-buster/Dockerfile
```

Build docker image for building purposes. 

```bash
sudo docker build --tag zfs-build-ubuntu-bionic:0.1 .
```

Build and install ZFS packages.

```bash
wget https://raw.githubusercontent.com/kobol-io/wiki/master/docs/helios64/software/zfs/install-zfs-buster/install-zfs-buster.sh 
chmod +x install-zfs-buster.sh
screen -L -Logfile buildlog.txt ./install-zfs-buster.sh 
tail -n40 buildlog.txt
```

On succeed, you may need to reboot and enable services:

```bash
sudo reboot
sudo systemctl enable zfs-import-cache  zsf-import.target  zfs-mount  zfs.target  zfs-zed
```
