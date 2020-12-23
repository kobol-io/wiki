!!! Important
    This install procedure only works with *Armbian Focal* for now. Instructions for *Armbian Buster* to be added soon.

So you already installed the system on eMMC or SD? You might want to use ZFS on the hard disk(s)! We assume rootfs is already on eMMC (or microSD Card) and you want to store your data on HDDs in ZFS pool.

!!! Note
    This wiki does not cover root-on-zfs. (Although it should be also possible.)



##  **Step 1** - Install ZFS

```bash
sudo armbian-config
```

Go to *Software* and install headers.

![Kernel Headers](/helios64/software/zfs/img/install-headers.png)

Once kernel headers installed, install ZFS with the following command:

```bash
sudo apt install zfs-dkms zfsutils-linux
```

Optional:

```bash
sudo apt install zfs-auto-snapshot
```

Reboot.

##  **Step 2** - Prepare partitions

Use `fdisk` of `gdisk` to create necessary partitions on your hard drive. This is beyond scope of this wiki.
When ready look for assigned uuids:

```bash
ls -l /dev/disk/by-partuuid/
```

##  **Step 3** - Create ZFS pool

```bash
sudo zpool create -o ashift=12 -m /mypool mypool mirror /dev/disk/by-partuuid/abc123 /dev/disk/by-partuuid/xyz789
sudo zfs set atime=off mypool
sudo zfs set compression=on mypool
```

Of course you may use more disks and create raidz instead of mirror. Your choice. :-)

Note: Do not use `/dev/sdXY` names. Use uuids only. This way your system will still work when you remove a disk or change order of disks.

If your disks are SSDs, enable trim support:
```bash
sudo zpool set autotrim=on mypool
```

##  **Step 4** - Reboot

After reboot make sure the pool was imported automatically:
```bash
zpool status
```

You should now have working system with root on eMMC and ZFS pool on HDD.

------------

*Page contributed by [michabbs](https://github.com/michabbs)*

*Reference [Armbian Forum Dicussion](https://forum.armbian.com/topic/16559-tutorial-first-steps-with-helios64-zfs-install-config/)*
