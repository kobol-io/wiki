The **mdadm** utility can be used to create and manage storage arrays using Linux's software RAID capabilities.

In this guide, we will show how to create different RAID configurations :

* RAID1 (for 2x HDD)
* RAID6 (for 4x HDD)
* RAID10 (for 4x HDD)

## Install mdadm

    sudo apt-get install mdadm

### Fix mdadm

You might see the following error message in your boot messages *"mdadm: initramfs boot message: /scripts/local-bottom/mdadm: rm: not found"*

To fix this minor issue simply edit the *mdadm* hook script of initramfs:

    sudo nano /usr/share/initramfs-tools/hooks/mdadm

Add **copy_exec /bin/rm /bin** after the following lines:

    copy_exec /sbin/mdadm /sbin
    copy_exec /sbin/mdmon /sbin

Then update initramfs:

    sudo update-initramfs -u

## Identify you Storage Drives

To get started, you will need first to identify the storage drives that you will use to compose your RAID array:

    lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT

Output

    NAME          SIZE FSTYPE TYPE MOUNTPOINT
    sda           1.8T        disk
    sdb           1.8T        disk
    sdc           1.8T        disk
    sdd           1.8T        disk
    mmcblk0      14.9G        disk
    └─mmcblk0p1  14.7G ext4   part /
    zram0          50M        disk /var/log
    zram1       504.4M        disk [SWAP]
    zram2       504.4M        disk [SWAP]

As you can see above, we have four drives without a filesystem, each of 1.8TB in size. So our drives are /dev/sda, /dev/sdb, /dev/sdc and /dev/sdd.

!!! note
    To avoid any confusion at identifying the right drive, start Helios4 without any type of USB storage connected to it.

## Create Array

### Create RAID 1 Array

To create a RAID 1 array with 2x drives, pass them to the mdadm --create command. You will have to specify the device name you wish to create (**/dev/md0** in our case), the RAID level, and the number of devices:

    sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sda /dev/sdb

If the drives you are using are not partitioned with the boot flag enabled, you will likely be given the following warning. It is safe to type **y** to continue:

    mdadm: Note: this array has metadata at the start and
        may not be suitable as a boot device.  If you plan to
        store '/boot' on this device please ensure that
        your boot-loader understands md/v1.x metadata, or use
        --metadata=0.90
    mdadm: size set to 1953383488K
    mdadm: automatically enabling write-intent bitmap on large array
    Continue creating array? y
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.


The mdadm tool will start to mirror the drives. This can take some time to complete, but the array can be used during this time. You can monitor the progress of the mirroring by checking the /proc/mdstat file:

    cat /proc/mdstat

Output

    Personalities : [raid1]
    md0 : active raid1 sdb[1] sda[0]
        1953383488 blocks super 1.2 [2/2] [UU]
        [>....................]  resync =  0.9% (19054272/1953383488) finish=213.6min speed=150885K/sec
        bitmap: 15/15 pages [60KB], 65536KB chunk

    unused devices: <none>

As you can see in the second line, the /dev/md0 device has been created with the RAID 1 configuration using the /dev/sda and /dev/sdb devices. The fourth line shows the progress on the mirroring. You can continue the guide while this process completes.

### Create RAID 6 Array

To create a RAID 6 array with 4x drives, pass them to the mdadm --create command. You will have to specify the device name you wish to create (**/dev/md0** in our case), the RAID level, and the number of devices:

    sudo mdadm --create --verbose /dev/md0 --level=6 --raid-devices=4 /dev/sda /dev/sdb /dev/sdc /dev/sdd

The mdadm tool will start to configure the array (it actually uses the recovery process to build the array for performance reasons). This can take some time to complete, but the array can be used during this time. You can monitor the progress of the mirroring by checking the /proc/mdstat file:

    cat /proc/mdstat

Output

    Personalities : [raid1] [raid0] [raid6] [raid5] [raid4] [raid10]
    md0 : active raid6 sdd[3] sdc[2] sdb[1] sda[0]
          3906766848 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4] [UUUU]
          [>....................]  resync =  0.3% (7171152/1953383424) finish=471.0min speed=68866K/sec
          bitmap: 15/15 pages [60KB], 65536KB chunk

    unused devices: <none>

As you can see in the second line, the /dev/md0 device has been created with the RAID 6 configuration using the /dev/sda, /dev/sdb, /dev/sdc and /dev/sdd devices. The fourth line shows the progress on the mirroring. You can continue the guide while this process completes.

### Create RAID 10 Array

To create a RAID 10 array with 4x drives, pass them to the mdadm --create command. You will have to specify the device name you wish to create (**/dev/md0** in our case), the RAID level, and the number of devices:

    sudo mdadm --create --verbose /dev/md0 --level=10 --raid-devices=4 /dev/sda /dev/sdb /dev/sdc /dev/sdd

The mdadm tool will start to configure the array (it actually uses the recovery process to build the array for performance reasons). This can take some time to complete, but the array can be used during this time. You can monitor the progress of the mirroring by checking the /proc/mdstat file:

    cat /proc/mdstat

Output

    Personalities : [raid1] [raid0] [raid6] [raid5] [raid4] [raid10]
    md0 : active raid10 sdd[3] sdc[2] sdb[1] sda[0]
          3906766848 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
          [>....................]  resync =  0.5% (20708608/3906766848) finish=305.0min speed=212294K/sec
          bitmap: 30/30 pages [120KB], 65536KB chunk

    unused devices: <none>

As you can see in the second line, the /dev/md0 device has been created with the RAID 10 configuration using the /dev/sda, /dev/sdb, /dev/sdc and /dev/sdd devices. The fourth line shows the progress on the mirroring. You can continue the guide while this process completes.

##  Create and Mount the Filesystem

!!! note
    The Helios4 System-On-Chip is a 32bit architecture, therefore the max partition size supported is 16TB. If your RAID array is more than 16TB of usable space, then you will need to create more than just one partition. You can use **fdisk /dev/md0** command to create several partitions on your array, then instead of using */dev/md0* for the below commands, it will be */dev/md0p1*, */dev/md0p2*, etc...

Create a filesystem on the array:

    sudo mkfs.ext4 -F /dev/md0

Create a mount point to attach the new filesystem:

    sudo mkdir -p /mnt/md0

You can mount the filesystem by typing:

    sudo mount /dev/md0 /mnt/md0

Check whether the new space is available by typing:

    df -h -x devtmpfs -x tmpfs

Output

    Filesystem      Size  Used Avail Use% Mounted on
    /dev/mmcblk0p1   15G  842M   14G   6% /
    /dev/zram0       49M  784K   45M   2% /var/log
    /dev/md0        1.8T   77M  1.7T   1% /mnt/md0


The new filesystem is mounted and accessible.

## Save the Array Layout

To make sure that the array is reassembled automatically at boot, we will have to modify /etc/mdadm/mdadm.conf file. You can automatically scan the active array and append the file by typing:

    sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf

Afterwards, you can update the initramfs, so that the array will be available during the early boot stage:

    sudo update-initramfs -u

Add the new filesystem mount options to the /etc/fstab file for automatic mounting at boot:

    echo '/dev/md0 /mnt/md0 ext4 defaults,nofail,discard 0 0' | sudo tee -a /etc/fstab

**Your RAID array should now automatically be assembled and mounted at each boot!**

## Reset Existing RAID Devices

!!! warning
    This process will completely destroy the array and any data written to it. Make sure that you are operating on the correct array and that you have copied off any data you need to retain prior to destroying the array.

Find the active arrays in the /proc/mdstat file by typing:

    cat /proc/mdstat

Output

    Personalities : [raid0] [linear] [multipath] [raid1] [raid6] [raid5] [raid4] [raid10]
    md0 : active raid6 sdd[3] sdc[2] sdb[1] sda[0]
          3906766848 blocks super 1.2 level 6, 512k chunk

    unused devices: <none>

Unmount the array from the filesystem:

    sudo umount /dev/md0

Then, stop and remove the array by typing:

    sudo mdadm --stop /dev/md0
    sudo mdadm --remove /dev/md0

Find the devices that were used to build the array with the following command:

    lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT

Output

    NAME          SIZE FSTYPE            TYPE  MOUNTPOINT
    sda           1.8T linux_raid_member disk  
    └─md0         3.7T ext4              raid6
    sdb           1.8T linux_raid_member disk  
    └─md0         3.7T ext4              raid6
    sdc           1.8T linux_raid_member disk  
    └─md0         3.7T ext4              raid6
    sdd           1.8T linux_raid_member disk  
    └─md0         3.7T ext4              raid6
    mmcblk0      14.9G                   disk  
    └─mmcblk0p1  14.7G ext4              part  /
    zram0          50M                   disk  /var/log
    zram1       504.4M                   disk  [SWAP]
    zram2       504.4M                   disk  [SWAP]

!!! important
    Keep in mind that the /dev/sd* names can change any time you reboot! Check them every time to make sure you are operating on the correct devices.

After discovering the devices used to create an array, zero their superblock to reset them to normal:

    sudo mdadm --zero-superblock /dev/sda
    sudo mdadm --zero-superblock /dev/sdb
    sudo mdadm --zero-superblock /dev/sdc
    sudo mdadm --zero-superblock /dev/sdd

You should remove any of the persistent references to the array. Edit the /etc/fstab file and comment out or remove the reference to your array:

```bash
sudo nano /etc/fstab

# /dev/md0 /mnt/md0 ext4 defaults,nofail,discard 0 0
```

Also, comment out or remove the array definition from the /etc/mdadm/mdadm.conf file:

```bash
sudo nano /etc/mdadm/mdadm.conf

# ARRAY /dev/md0 metadata=1.2 name=mdadmwrite:0 UUID=7261fb9c:976d0d97:30bc63ce:85e76e91
```

Finally, update the initramfs again:

    sudo update-initramfs -u

At this point, you should be ready to reuse the storage devices individually, or as components of a different array.

*Tuto Source: [link](https://www.digitalocean.com/community/tutorials/how-to-create-raid-arrays-with-mdadm-on-ubuntu-16-04)*
