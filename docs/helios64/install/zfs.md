# ZFS on HDD

So you already installed the system on eMMC or SD? You might want to use ZFS on the hard disk(s)!

Note: This wiki does not cover root-on-zfs. (Althrough it should be also possible.) We assume rootfs is already on eMMC (or SD) and you want to keep your data on HDDs in ZFS pool.

Important: *Focal* is required. Do not use Buster.

## **Step 1** - Install Focal on eMMC

See necessary steps [here](/helios64/install/transfer).

##  **Step 2** - Install ZFS

```bash
sudo armbian-config
```

Go to Software and install headers.

```bash
sudo apt install zfs-dkms zfsutils-linux
```

Optional:
```bash
sudo apt install zfs-auto-snapshot
```

Reboot.

##  **Step 3** - Prepare partitions

Use `fdisk` of `gdisk` to create necessary partitions on your hard drive. This is beyond scope of this wiki.
When ready look for assigned uuids:

```bash
ls -l /dev/disk/by-partuuid/
```

##  **Step 4** - Create ZFS pool

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

##  **Step 5** - Reboot

After reboot make sure the pool was imported automatically:
```bash
zpool status
```

You should now have working system with root on eMMC and ZFS pool on HDD.

