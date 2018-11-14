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

## Check your RAID Array State

To get a detailed picture of your array setup and its state you can use the following command:

    sudo mdadm -D /dev/md0

This is the output when the array is in good health, you can see the line showing **State : clean**.

    /dev/md0:
            Version : 1.2
      Creation Time : Sun Jul 29 14:59:58 2018
         Raid Level : raid10
         Array Size : 3906766848 (3725.78 GiB 4000.53 GB)
      Used Dev Size : 1953383424 (1862.89 GiB 2000.26 GB)
       Raid Devices : 4
      Total Devices : 4
        Persistence : Superblock is persistent

      Intent Bitmap : Internal

        Update Time : Tue Nov 13 06:21:03 2018
              State : clean
     Active Devices : 4
    Working Devices : 4
     Failed Devices : 0
      Spare Devices : 0

             Layout : near=2
         Chunk Size : 512K

               Name : helios4:0  (local to host helios4)
               UUID : ea143418:153e050e:ac86d56c:07547815
             Events : 95892

        Number   Major   Minor   RaidDevice State
           0       8        0        0      active sync set-A   /dev/sda
           1       8       16        1      active sync set-B   /dev/sdb
           2       8       32        2      active sync set-A   /dev/sdc
           3       8       48        3      active sync set-B   /dev/sdd

In below example the array has a failed drive, you can see the line **State : clean, degraded** and that the RaidDevice 2 (/dev/sdc) is removed. The array is still active but in a degraded state because it requires /dev/sdc to be replaced as soon as possible.

    /dev/md0:
            Version : 1.2
      Creation Time : Sun Jul 29 14:59:58 2018
         Raid Level : raid10
         Array Size : 3906766848 (3725.78 GiB 4000.53 GB)
      Used Dev Size : 1953383424 (1862.89 GiB 2000.26 GB)
       Raid Devices : 4
      Total Devices : 3
        Persistence : Superblock is persistent

      Intent Bitmap : Internal

        Update Time : Tue Nov 13 08:34:06 2018
              State : clean, degraded
     Active Devices : 3
    Working Devices : 3
     Failed Devices : 0
      Spare Devices : 0

             Layout : near=2
         Chunk Size : 512K

               Name : helios4:0  (local to host helios4)
               UUID : ea143418:153e050e:ac86d56c:07547815
             Events : 95892

        Number   Major   Minor   RaidDevice State
           0       8        0        0      active sync set-A   /dev/sda
           1       8       16        1      active sync set-B   /dev/sdb
           -       0        0        2      removed             /dev/sdc
           3       8       48        3      active sync set-B   /dev/sdd

           2       8       32        -      faulty   /dev/sdc

## Replace a Failed Drive

Once you have identified the failed drive with the command **mdadm -D**, as shown in the previous section, you will need to do the following steps to replace the failed drive:

1. Mark the faulty drive as failed.

    `mdadm /dev/md0 --fail /dev/sdc`

2. Remove the drive from the array.

    `mdadm /dev/md0 --remove /dev/sdc`

3. Identify which physical drive is to be replaced.

    `readlink -f  on /sys/block/* | grep sdc`

    `/sys/devices/platform/soc/soc:internal-regs/f10e0000.sata/ata3/host2/target2:0:0/2:0:0:0/block/sdc`

    In this example the faulty drive is the one connected to the SATA port 3 (**ata3**) of the board.

4. Shutdown your system and replace the faulty drive.

    `sudo halt`

5. Power-up your Helios4.

6. Add the new drive to the array. You will need to use **lsblk** command to figure out what's the device name of the new drive. Most probably it will be the same than before.

    `sudo mdadm /dev/md0 --add /dev/sdc`

Finally check the array is correctly re-building the new drive.

`sudo mdadm -d /dev/md0`

    Number   Major   Minor   RaidDevice State
     0       8        0        0      active sync set-A   /dev/sda
     1       8       16        1      active sync set-B   /dev/sdb
     4       0        0        2      spare rebuilding    /dev/sdc
     3       8       48        3      active sync set-B   /dev/sdd

We can see that /dev/sdc is being rebuilt.

`cat /proc/mdstat`

    Personalities : [raid1] [raid0] [raid6] [raid5] [raid4] [raid10]
    md0 : active raid10 sdd[3] sdc[4] sdb[1] sda[0]
          3906766848 blocks super 1.2 512K chunks 2 near-copies [4/4] [UU_U]
          [>....................]  recovery =  0.5% (20708608/3906766848) finish=305.0min speed=212294K/sec

You can see the rebuild progress.


## Setup Error Notification (Recommended)

In order to get notified or to see visual indication that something is wrong with your array you can configure *email alerts* and/or *error LED*.

### Configure Email Alerts

Receive a notification whenever mdadm detects something wrong with your array. This is very important since you don't want to miss out an issue on your array in order to have time to take the right actions.

    sudo nano /etc/mdadm/mdadm.conf

Edit the following section and replace root by your email address.

    # instruct the monitoring daemon where to send mail alerts
    MAILADDR root

!!! important
    You will need to install and configure **postfix** or **sendmail**.

### Configure Error LED

!!! note
    To be done.

### Test alerts

You can test your error notification setup by doing the following:

`sudo systemctl stop mdmonitor.service`

`sudo mdadm --monitor --scan --test -1`

`sudo systemctl start mdmonitor.service`


## Import an Existing RAID Array

If for some reasons you want to add an existing array to your system (e.g you just did a new fresh install of your operating system), you can use the following command to detect your existing array.

    sudo mdadm —assemble —scan

Then refer to previous sections to mount the file system and save its layout in mdadm configuration.

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

At this point, you should be ready to reuse the storage devices individually, or as devices of a different array.

*Tuto Source: [link](https://www.digitalocean.com/community/tutorials/how-to-create-raid-arrays-with-mdadm-on-ubuntu-16-04)*
