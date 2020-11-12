Armbian provides a utility called *nand-sata-install* to transfer OS from SD card to other device such as USB, SATA, or NVMe.
The utility can be invoke directly,

```
sudo nand-sata-install
```

or the recommended way, through *armbian-config*

```
sudo armbian-config
```

Helios64 support following boot mode

| Boot Device | System / Rootfs Device |
|-------------|------------------------|
| eMMC | eMMC<br>SATA Drive<br>USB Drive|

Boot device contains bootloader and other boot files such as kernel and DTB. It will be mounted under **/boot/** if it resides on separate device.

!!! Notes
    *nand-sata-install* requires the target device to be already partitioned!

!!! Important
    If you have installed and configured OMV, please read [Existing OS Has OMV Installed](#existing-os-has-omv-installed) section before transferring the OS.

## System on eMMC

***Step 1 - Run Armbian Configuration Utility***

![emmc step 0](/helios64/install/img/transfer/emmc_00_config_main.png)

***Step 2 - Select Install Menu***

![emmc step 1](/helios64/install/img/transfer/emmc_01_config_system.png)

***Step 3 - Select Boot from eMMC - system on eMMC***

![emmc step 2](/helios64/install/img/transfer/emmc_02_install_main.png)

***Step 4 - Confirm that the process will erase data on eMMC***

![emmc step 3](/helios64/install/img/transfer/emmc_03_install_erase_confirm.png)

***Step 5 - Select filesystem type for eMMC***

![emmc step 4](/helios64/install/img/transfer/emmc_04_install_fstype.png)

***Step 6 - Wait for transfer process to complete***

![emmc step 5](/helios64/install/img/transfer/emmc_05_install_transfer.png)

***Step 7 - Power Off Helios64 if you don't have OMV Installed***

**DO NOT** power off if you have installed OMV. There are several OMV files & folders not transferred by *nand-sata-install*. Please refer to [After running *nand-sata-install*](#existing-os-has-omv-installed) section before continue to next step.

![emmc step 6](/helios64/install/img/transfer/emmc_06_install_poweroff.png)

***Step 8 - Remove Micro SD card and power on the system***

***Step 9 - Verify if the system transferred correctly***

```
lsblk

NAME         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda            8:0    0 111.8G  0 disk
└─sda1         8:1    0 111.8G  0 part
sdb            8:16   0 111.8G  0 disk
└─sdb1         8:17   0 111.8G  0 part
sdc            8:32   1  28.7G  0 disk
└─sdc1         8:33   1  28.4G  0 part
mmcblk1      179:0    0  14.6G  0 disk
└─mmcblk1p1  179:1    0  14.4G  0 part /
mmcblk1boot0 179:32   0     4M  1 disk
mmcblk1boot1 179:64   0     4M  1 disk
zram0        251:0    0    50M  0 disk /var/log
zram1        251:1    0   1.9G  0 disk [SWAP]
```

You should see **mmcblk1p1** has MOUNTPOINT **/**

## System on USB or SATA (Including M.2 SATA)

List available block devices and determine the type by running

```
lsblk
ls -l /sys/block/
```

Example output:

```
dev@helios64:~# lsblk
NAME         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda            8:0    0 111.8G  0 disk
└─sda1         8:1    0 111.8G  0 part
sdb            8:16   0 111.8G  0 disk
└─sdb1         8:17   0 111.8G  0 part
sdc            8:32   1  28.7G  0 disk
└─sdc1         8:33   1  28.4G  0 part
mmcblk0      179:0    0  14.9G  0 disk
└─mmcblk0p1  179:1    0  14.7G  0 part /
mmcblk1      179:32   0  14.6G  0 disk
└─mmcblk1p1  179:33   0  14.4G  0 part
mmcblk1boot0 179:64   0     4M  1 disk
mmcblk1boot1 179:96   0     4M  1 disk
zram0        251:0    0    50M  0 disk /var/log
zram1        251:1    0   1.9G  0 disk [SWAP]

dev@helios64:~# ls -l /sys/block/
total 0
lrwxrwxrwx 1 root root 0 Nov  5 10:13 loop0 -> ../devices/virtual/block/loop0
lrwxrwxrwx 1 root root 0 Nov  5 10:13 loop1 -> ../devices/virtual/block/loop1
lrwxrwxrwx 1 root root 0 Nov  5 10:13 loop2 -> ../devices/virtual/block/loop2
lrwxrwxrwx 1 root root 0 Nov  5 10:13 loop3 -> ../devices/virtual/block/loop3
lrwxrwxrwx 1 root root 0 Nov  5 10:13 loop4 -> ../devices/virtual/block/loop4
lrwxrwxrwx 1 root root 0 Nov  5 10:13 loop5 -> ../devices/virtual/block/loop5
lrwxrwxrwx 1 root root 0 Nov  5 10:13 loop6 -> ../devices/virtual/block/loop6
lrwxrwxrwx 1 root root 0 Nov  5 10:13 loop7 -> ../devices/virtual/block/loop7
lrwxrwxrwx 1 root root 0 Nov  5 10:13 mmcblk0 -> ../devices/platform/fe320000.mmc/mmc_host/mmc0/mmc0:aaaa/block/mmcblk0
lrwxrwxrwx 1 root root 0 Nov  5 10:13 mmcblk1 -> ../devices/platform/fe330000.sdhci/mmc_host/mmc1/mmc1:0001/block/mmcblk1
lrwxrwxrwx 1 root root 0 Nov  5 10:13 mmcblk1boot0 -> ../devices/platform/fe330000.sdhci/mmc_host/mmc1/mmc1:0001/block/mmcblk1/mmcblk1boot0
lrwxrwxrwx 1 root root 0 Nov  5 10:13 mmcblk1boot1 -> ../devices/platform/fe330000.sdhci/mmc_host/mmc1/mmc1:0001/block/mmcblk1/mmcblk1boot1
lrwxrwxrwx 1 root root 0 Nov  5 10:13 sda -> ../devices/platform/f8000000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0/ata1/host0/target0:0:0/0:0:0:0/block/sda
lrwxrwxrwx 1 root root 0 Nov  5 10:13 sdb -> ../devices/platform/f8000000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0/ata4/host3/target3:0:0/3:0:0:0/block/sdb
lrwxrwxrwx 1 root root 0 Nov  5 10:13 sdc -> ../devices/platform/usb@fe900000/fe900000.usb/xhci-hcd.0.auto/usb2/2-1/2-1.3/2-1.3:1.0/host5/target5:0:0/5:0:0:0/block/sdc
lrwxrwxrwx 1 root root 0 Nov  5 10:13 zram0 -> ../devices/virtual/block/zram0
lrwxrwxrwx 1 root root 0 Nov  5 10:13 zram1 -> ../devices/virtual/block/zram1
lrwxrwxrwx 1 root root 0 Nov  5 10:13 zram2 -> ../devices/virtual/block/zram2
```

From output above, the types are:

| Block Device | Physical drive | Remarks |
|--------------|----------------|---------|
| **mmcblk0** | micro SD card | |
| **mmcblk1** | eMMC | |
| **sda** | SATA or M.2 drive connected to Port 1 | *../devices/platform/f8000000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0/***ata1***/* |
| **sdb** | SATA drive connected to Port 4 | *../devices/platform/f8000000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0/***ata4***/* |
| **sdc** | USB drive connected to USB Port 3 (Front Panel) | *../devices/platform/usb@fe900000/fe900000.usb/xhci-hcd.0.auto/usb2/2-1/2-1***.3***/* |


***Step 1 - Run Armbian Configuration Utility***

```
sudo armbian-config
```

![sata step 0](/helios64/install/img/transfer/sata_usb_00_config_main.png)

***Step 2 - Select Install Menu***

![sata step 1](/helios64/install/img/transfer/sata_usb_01_config_system.png)

***Step 3 - Select Boot from eMMC - system on SATA, USB or NVMe***

![sata step 2](/helios64/install/img/transfer/sata_usb_02_install_main.png)

**Step 4 - Select storage device and partition for rootfs***

  *SATA drive at port 1 as System drive*

  ![sata step 3a](/helios64/install/img/transfer/sata_usb_03_select_target_sata.png)

---

  *USB drive as System drive*

  ![sata step 3b](/helios64/install/img/transfer/sata_usb_03_select_target_usb.png)


***Step 5 - Confirm that the process will erase data on eMMC and system partition***

![sata step 4](/helios64/install/img/transfer/sata_usb_04_install_erase_confirm.png)

***Step 6 - Select filesystem type for eMMC***

![sata step 5](/helios64/install/img/transfer/sata_usb_05_install_boot_fstype.png)

Wait until formatting process completed

![sata step 6](/helios64/install/img/transfer/sata_usb_06_install_format_boot.png)

***Step 7 - Select filesystem type for system partition***

![sata step 7](/helios64/install/img/transfer/sata_usb_07_install_system_fstype.png)

Wait until formatting process is completed

![sata step 8](/helios64/install/img/transfer/sata_usb_08_install_format_system.png)

***Step 8 - Wait for transfer process to be completed***

![sata step 9](/helios64/install/img/transfer/sata_usb_09_install_transfer.png)

***Step 9 - Power Off Helios64 if you don't have OMV Installed***

**DO NOT** power off if you have installed OMV. There are several OMV files & folders not transferred by *nand-sata-install*. Please refer to [After running *nand-sata-install*](#existing-os-has-omv-installed) section before continue to next step.

![sata step 10](/helios64/install/img/transfer/sata_usb_10_install_poweroff.png)

***Step 10 - Remove Micro SD card and power on the system***

***Step 11 - Verify if the system transferred correctly***

*System on SATA or M.2*

```
lsblk

NAME         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda            8:0    0 111.8G  0 disk
└─sda1         8:1    0 111.8G  0 part /
sdb            8:16   0 111.8G  0 disk
└─sdb1         8:17   0 111.8G  0 part
sdc            8:32   1  28.7G  0 disk
└─sdc1         8:33   1  28.4G  0 part
mmcblk1      179:0    0  14.6G  0 disk
└─mmcblk1p1  179:1    0  14.4G  0 part /media/mmcboot
mmcblk1boot0 179:32   0     4M  1 disk
mmcblk1boot1 179:64   0     4M  1 disk
zram0        251:0    0    50M  0 disk /var/log
zram1        251:1    0   1.9G  0 disk [SWAP]
```

You should see SATA drive at Port 1 has MOUNTPOINT **/** and eMMC has MOUNTPOINT **/media/mmcboot**

---

*System on USB*

```
lsblk

NAME         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda            8:0    0 111.8G  0 disk
└─sda1         8:1    0 111.8G  0 part
sdb            8:16   0 111.8G  0 disk
└─sdb1         8:17   0 111.8G  0 part
sdc            8:32   1  28.7G  0 disk
└─sdc1         8:33   1  28.4G  0 part /
mmcblk1      179:0    0  14.6G  0 disk
└─mmcblk1p1  179:1    0  14.4G  0 part /media/mmcboot
mmcblk1boot0 179:32   0     4M  1 disk
mmcblk1boot1 179:64   0     4M  1 disk
zram0        251:0    0    50M  0 disk /var/log
zram1        251:1    0   1.9G  0 disk [SWAP]
```

You should see USB drive has MOUNTPOINT **/** and eMMC has MOUNTPOINT **/media/mmcboot**


## Transfer rootfs from eMMC to SATA or USB

List available block devices and determine the type by running

```
lsblk
ls -l /sys/block/
```

Example output:

```
dev@helios64:~$ lsblk
NAME         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda            8:0    0 111.8G  0 disk
└─sda1         8:1    0 111.8G  0 part
sdb            8:16   0 111.8G  0 disk
└─sdb1         8:17   0 111.8G  0 part
sdc            8:32   1  28.7G  0 disk
└─sdc1         8:33   1  28.4G  0 part
mmcblk1      179:0    0  14.6G  0 disk
└─mmcblk1p1  179:1    0  14.4G  0 part /
mmcblk1boot0 179:32   0     4M  1 disk
mmcblk1boot1 179:64   0     4M  1 disk

dev@helios64:~$ ls -l /sys/block
total 0
lrwxrwxrwx 1 root root 0 Nov 11 04:19 loop0 -> ../devices/virtual/block/loop0
lrwxrwxrwx 1 root root 0 Nov 11 04:19 loop1 -> ../devices/virtual/block/loop1
lrwxrwxrwx 1 root root 0 Nov 11 04:19 loop2 -> ../devices/virtual/block/loop2
lrwxrwxrwx 1 root root 0 Nov 11 04:19 loop3 -> ../devices/virtual/block/loop3
lrwxrwxrwx 1 root root 0 Nov 11 04:19 loop4 -> ../devices/virtual/block/loop4
lrwxrwxrwx 1 root root 0 Nov 11 04:19 loop5 -> ../devices/virtual/block/loop5
lrwxrwxrwx 1 root root 0 Nov 11 04:19 loop6 -> ../devices/virtual/block/loop6
lrwxrwxrwx 1 root root 0 Nov 11 04:19 loop7 -> ../devices/virtual/block/loop7
lrwxrwxrwx 1 root root 0 Nov 11 04:19 mmcblk1 -> ../devices/platform/fe330000.sdhci/mmc_host/mmc1/mmc1:0001/block/mmcblk1
lrwxrwxrwx 1 root root 0 Nov 11 04:19 mmcblk1boot0 -> ../devices/platform/fe330000.sdhci/mmc_host/mmc1/mmc1:0001/block/mmcblk1/mmcblk1boot0
lrwxrwxrwx 1 root root 0 Nov 11 04:19 mmcblk1boot1 -> ../devices/platform/fe330000.sdhci/mmc_host/mmc1/mmc1:0001/block/mmcblk1/mmcblk1boot1
lrwxrwxrwx 1 root root 0 Nov 11 04:19 sda -> ../devices/platform/f8000000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0/ata1/host0/target0:0:0/0:0:0:0/block/sda
lrwxrwxrwx 1 root root 0 Nov 11 04:19 sdb -> ../devices/platform/f8000000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0/ata4/host3/target3:0:0/3:0:0:0/block/sdb
lrwxrwxrwx 1 root root 0 Nov 11 04:19 sdc -> ../devices/platform/usb@fe900000/fe900000.usb/xhci-hcd.0.auto/usb2/2-1/2-1.3/2-1.3:1.0/host5/target5:0:0/5:0:0:0/block/sdc
```

From output above, the types are:

| Block Device | Physical drive | Remarks |
|--------------|----------------|---------|
| **mmcblk1** | eMMC | |
| **sda** | SATA or M.2 drive connected to Port 1 | *../devices/platform/f8000000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0/***ata1***/* |
| **sdb** | SATA drive connected to Port 4 | *../devices/platform/f8000000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0/***ata4***/* |
| **sdc** | USB drive connected to USB Port 3 (Front Panel) | *../devices/platform/usb@fe900000/fe900000.usb/xhci-hcd.0.auto/usb2/2-1/2-1***.3***/* |

***Step 1 - Run Armbian Configuration Utility***

```
sudo armbian-config
```

![emmc step 0](/helios64/install/img/transfer/emmc_sata_00_config_main.png)

***Step 2 - Select Install Menu***

![emmc step 1](/helios64/install/img/transfer/emmc_sata_01_config_system.png)

***Step 3 - Select Boot from SD - system on SATA, USB or NVMe***

!!! Info
    The utility has flaw that it mistakenly read current boot device as SD card instead of eMMC. But it actually set the eMMC as boot device and system on SATA or USB device.

![emmc step 2](/helios64/install/img/transfer/emmc_sata_02_install_menu.png)

***Step 4 - Select storage device and partition for rootfs***

  *SATA drive at port 1 as System drive*

  ![emmc step 3a](/helios64/install/img/transfer/emmc_sata_03_install_select_target_sata.png)

---

  *USB drive as System drive*

  ![emmc step 3b](/helios64/install/img/transfer/emmc_sata_03_install_select_target_usb.png)

***Step 5 - Confirm that the process will erase data on eMMC and system partition***

![emmc step 4](/helios64/install/img/transfer/emmc_sata_04_install_erase_confirmation.png)

***Step 6 - Select filesystem type for eMMC***

![emmc step 5](/helios64/install/img/transfer/emmc_sata_05_install_fstype.png)

Wait until formatting process is completed

![emmc step 6](/helios64/install/img/transfer/emmc_sata_06_install_format.png)

***Step 7 - Wait for transfer process to be completed***

![emmc step 9](/helios64/install/img/transfer/emmc_sata_07_install_transfer.png)

***Step 8 - Reboot Helios64 if you don't have OMV Installed***

**DO NOT** reboot if you have installed OMV. There are several OMV files & folders not transferred by *nand-sata-install*. Please refer to [After running *nand-sata-install*](#existing-os-has-omv-installed) section before continue to next step.

![emmc step 10](/helios64/install/img/transfer/emmc_sata_08_install_reboot.png)

***Step 9 - Power on the system***

***Step 10 - Verify if the system transferred correctly***

*System on SATA or M.2*

```
lsblk

NAME         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda            8:0    0 111.8G  0 disk
└─sda1         8:1    0 111.8G  0 part /
sdb            8:16   0 111.8G  0 disk
└─sdb1         8:17   0 111.8G  0 part
sdc            8:32   1  28.7G  0 disk
└─sdc1         8:33   1  28.4G  0 part
mmcblk1      179:0    0  14.6G  0 disk
└─mmcblk1p1  179:1    0  14.4G  0 part /media/mmcboot
mmcblk1boot0 179:32   0     4M  1 disk
mmcblk1boot1 179:64   0     4M  1 disk
zram0        251:0    0    50M  0 disk /var/log
zram1        251:1    0   1.9G  0 disk [SWAP]
```

You should see SATA drive at Port 1 has MOUNTPOINT **/** and eMMC has MOUNTPOINT **/media/mmcboot**

---

*System on USB*

```
lsblk

NAME         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda            8:0    0 111.8G  0 disk
└─sda1         8:1    0 111.8G  0 part
sdb            8:16   0 111.8G  0 disk
└─sdb1         8:17   0 111.8G  0 part
sdc            8:32   1  28.7G  0 disk
└─sdc1         8:33   1  28.4G  0 part /
mmcblk1      179:0    0  14.6G  0 disk
└─mmcblk1p1  179:1    0  14.4G  0 part /media/mmcboot
mmcblk1boot0 179:32   0     4M  1 disk
mmcblk1boot1 179:64   0     4M  1 disk
zram0        251:0    0    50M  0 disk /var/log
zram1        251:1    0   1.9G  0 disk [SWAP]
```

You should see USB drive has MOUNTPOINT **/** and eMMC has MOUNTPOINT **/media/mmcboot**

## Existing OS Has OMV Installed

Transferring rootfs using *nand-sata-install* will break OMV due to missing files. To prevent this, you need to perform the following actions.

### Preparation before running *nand-sata-install*

If you have configured NFS share located on SATA drive(s), you might like to prevent the content to be copied over to eMMC. run following command to prevent it

```
echo "/export/*" | sudo tee -a /usr/lib/nand-sata-install/exclude.txt
```

Lastly, if you're using ZFS, which by default mounts to **/<pool_name>**, make sure to add its mountpoint to **/usr/lib/nand-sata-install/exclude.txt** before running *nand-sata-install* as well.

### After running *nand-sata-install*

OMV 5 stores part of its config (**salt** and **pillar** folders) in **/srv/** which are excluded by *nand-sata-install*.

Before power off the system to finalize the system transfer, we need to mount system partition and copy those folders into it and finally power off the system.

```
sudo mkdir -p /mnt/system
sudo mount /dev/sda1 /mnt/system
sudo cp -rf -t /mnt/system/srv/ /srv/salt /srv/pillar
sudo poweroff
```

!!! Note
    Pay attention to block device of system partition at second command. In this case /dev/sda1 is SATA drive at Port 1.

Now you can resume back to the steps your were following.


## References

- [Armbian Documentation](https://docs.armbian.com/User-Guide_Getting-Started/#how-to-install-to-emmc-nand-sata-usb)

- [Tips from antsu at Armbian Forum](https://forum.armbian.com/topic/15431-helios64-support/?do=findComment&comment=110715)
