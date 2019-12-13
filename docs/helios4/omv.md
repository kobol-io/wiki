This is a basic guide to help you setting up Helios4 NAS with [OpenMediaVault](https://www.openmediavault.org/) (**OMV**). OMV offers a large collection of features that we don't cover here. We invite you to look online for the existing OMV guides or go on the [OMV forum](https://forum.openmediavault.org/index.php/Board/29-Guides/).

!!! info
    The following guide was written for OMV3 (Erasmus), but it still works with OMV4 (Arrakis) since the interface is the same.

!!! important
    As of July 2019, OMV5 (Usul) is still in Beta and Unstable, therefore we strongly recommend using OMV4 (Arrakis) for now. In order to install OMV4, you need to be running Debian 9 Stretch.

## What is OpenMediaVault?

OpenMediaVault (OMV) is a next-gen network attached storage (NAS) software based on Debian Linux. It contains services like SSH, (S)FTP, SMB/CIFS, DAAP media server, RSync, BitTorrent client and many more... all configurable via a Web Control Panel. Thanks to a modular framework design, new features can be added to OMV via plugins. It is a simple and easy to use out-of-the-box solution that will allow everyone to install and administrate a Network Attached Storage without deeper knowledge.

## Install Openmediavault

You can easily install OMV with the **armbian-config** tool.

Connect to your Helios4 via SSH as explained [here](/helios4/install/#step-7-connect-to-helios4-via-ssh).

Launch **armbian-config** and follow the steps.

```bash
sudo armbian-config
```

![!armbian-config Main Menu](/helios4/img/omv/install-1.png)

![!armbian-config Software](/helios4/img/omv/install-2.png)

Select **OMV** and press **Install**.

![!armbian-config Selection](/helios4/img/omv/install-3.png)

This is what you will see during the installation.

![!armbian-config Install](/helios4/img/omv/install-4.png)

When installation is completed, you should see the following menu with **Samba** and **OMV** shown as installed.

![!armbian-config Install Complete](/helios4/img/omv/install-5.png)

Now press **ESC** till you exit armbian-config tool.

You might want to reboot to be sure all OMV services are started properly.
```bash
sudo reboot
```

## Connect to OpenMediaVault (OMV) Control Panel

Open your web browser and go to the one of the following addresses :

* http://helios4.local<br>
* http://*xxx.xxx.xxx.xxx* ([How to check Helios4 IP address](/helios4/install/#step-6-checkset-ip-address))

**Default credential :**

* Username: admin
* Password: openmediavault

![!OMV Login](/helios4/img/omv/login.png)
*Login Screen*

![!OMV Dashboard](/helios4/img/omv/dashboard.png)
*Dashboard View*

## Wipe Disk (Optional)

If you are using HDDs which aren't blank or brand new you might need to wipe them first before being able to setup a RAID array.

> Go to **Physical Disks** page in *Storage* section.

> Select an HDD and click **Wipe**.

!!! note
    HDDs are the devices starting with **/dev/sdX**

![!OMV HDD Wipe](/helios4/img/omv/disk_wipe1.png)

> Click **Quick** wipe method.

![!OMV HDD Wipe](/helios4/img/omv/disk_wipe2.png)

> Repeat above steps for each HDD you want to use for your RAID array.


## Create a RAID array

In this guide we chose to create a RAID10 with 4 HDDs for the following reasons :

- Best performance, less compute intensive.
- Fastest (re)build, less performance degradation.
- Support up to 2 disk failures, but not every 2 disk failures combination like RAID6.

!!! info
    You can choose to go for  RAID6 but take in consideration that the building will take up to 3 times the building time of RAID10. There are plenty of threads online which compare the pros and cons between each RAID option.

> Go to **RAID Management** page in *Storage* section.

> Click **Create**.

> Select RAID level and the devices you want to use for the RAID array.

> Give it a name and click **Create**.


![!OMV RAID 10](/helios4/img/omv/create_raid10.png)

You can see the ongoing build / re-syncing process and get an estimated finish time.

![!OMV RAID Syncing](/helios4/img/omv/syncing_raid10.png)

!!! important
    While you could carry on with some part of OMV configuration during the RAID re-syncing process, we strongly advice to let this process complete first. You should see the following in the RAID state once re-syncing is complete : **active**.

!!! note
    If your system is configured to [display RAID fault on the LED2](/helios4/mdadm/#configure-fault-led), then you should also see the red LED2 blinking while your array is (re-)syncing.

![!OMV RAID Clean](/helios4/img/omv/raid10_active.png)

!!! info
    Whenever you change some settings in OMV, the following banner will appear. You can immediately apply the configuration by clicking **Apply** or you can carry on with your configuration and apply the changes at a later stage.

![!OMV Save Settings](/helios4/img/omv/save_settings.png)

## Install LVM Plugin

To have a better control of storage partitioning we will use Linux Logical Volume Manager (LVM). To create Logical Volume in OMV you will need first to install the LVM plugin.

> Go to **Plugins** page in *System* section.

![!Plugin List](/helios4/img/omv/plugin_list.png)

To get the latest plugins you will need to update the plugins database.

> Click **Check**

![!Plugin Update](/helios4/img/omv/plugin_update.png)

Once plugins database update is done :

> Search for *lvm* in the search field.

> Select openmediavault-lvm2 and click **Install**.

![!Plugin LVM](/helios4/img/omv/plugin_lvm.png)

> Wait till the lvm plugins install shows *Done...* then click **Close**.

![!Plugin Install](/helios4/img/omv/plugin_install.png)

!!! info
    OMV Control Panel will reload and you should see the **Logical Volume Management** page in *Storage* section.

## Create a LVM Logical Volume  

To create a Logical Volume 3 steps are necessary :

1. Add a Physical Volume. (The RAID array you created previously)
2. Add a Volume Group. (Volume Group contains Physical Volumes)
3. Add one ore more Logical Volumes. (Logical Volumes are like partitions)

!!! note
    The Helios4 System-On-Chip is a 32bit architecture, therefore the max volume size supported is 16TB. If your RAID array is more than 16TB of usable space, then you will need to create more than just one Logical Volume to take advantage of all the available space.

> Go to **Logical Volume Management** page in *Storage* section.

> Click **Add** under *Physical Volumes* tab.

> Select the RAID array you created previously and click **Save**.


![!LVM Add Physical Volume](/helios4/img/omv/lvm_add-pv.png)

> Go to *Volume groups* tab.

> Click **Add**.

> Select the Physical Volume you just created.

> Give it a name and click **Save**.

![!LVM Add Volume Group](/helios4/img/omv/lvm_add-vg.png)

> Go to *Logical volumes* tab.

> Click **Add**.

> Select the Volume Group you just created.

> Choose a partition size.

> Give it a name and click **Save**.

![!LVM Add Logical Volume](/helios4/img/omv/lvm_add-lv.png)

!!! info
    You can create several Logical Volumes according to your needs and the way you want to organize your data.

    In the current example we created 2 volumes :

    - public : to put all non-sensitive data like movie & music collections.
    - secure : to setup an encrypted space for sensitive data (not covered in this guide).

![!LVM Volumes](/helios4/img/omv/lvm_lv-volumes.png)


## Format and Mount Volume

Now that your Logical Volumes are created, you need to format and mount them in order to use them.

> Go to **File System** page in *Storage* section.

> Click **Create**

> Choose a Logical Volume you created.

> Choose a File system type (e.g EXT4).

> Give it a label and click **OK**.

!!! info
    While you could choose BTRFS as a copy-on-write File system (COW), we recommend to use to EXT4 unless you know how to take advantage of BTRFS features.

![!Format Volume](/helios4/img/omv/format_volume.png)

You can see the ongoing formatting process. You don't have to wait the process to finish.

> Click **Close**.

![!Format Process](/helios4/img/omv/format_process.png)

You can check the status of all devices.

Once formatting process is complete, device status will show *Online*.

!!! info
    Depending on your Logical Volume size, formatting can take a while to complete.

![!Format Status](/helios4/img/omv/format_status.png)

> Select device you formatted and click **Mount**.

![!Mount Volume](/helios4/img/omv/mount_volume.png)

> Repeat the action for each Logical Volume you created.

## Create User

In this guide we will create a super user *john* that will have the write access on the share folders we will create. We will also give SSH access and sudo right to this user.

> Go to **User** page in *Access Rights Management* section.

> Click **Add** under *Users* tab.

> Fill Name and Password section.

> Select */bin/bash* for Shell (Optional).

![!User Create](/helios4/img/omv/user_create.png)

> Go to *Groups* tab.

> Activate group *ssh* and *sudo*.

> Click **Save**.

![!User Group](/helios4/img/omv/user_group.png)

## Create Shared Folder

Now you need to create Shared Folders that will be exposed through network sharing services. OMV offers many sharing service options, however in this guide we only show how to setup a Windows Share which is the most common option.

> Go to **Share Folders** page in *Access Rights Management* section.

> Click **Add**.

> Fill Name (e.g movie).

> Select Device which is one of the Logical Volumes you created and mounted previously.

> Change Path Name if necessary.

!!! info
    You can leave the default permission. But later on you should explore how the permissions settings work and impact your Share Folders.

![!Folder Add](/helios4/img/omv/folder_add.png)

> Repeat the action to add more Share Folders.

Once done you can see the list of Share Folders you have created and under which Device / Logical Volume they are.

![!Folder List](/helios4/img/omv/folder_list.png)

## Configure Windows Share (SMB/CIFS)

We will now activate the Windows Share service (a.k.a SMB/CIFS) and enlist the Share Folders you created previously.

> Go to **SMB/CIFS** page in *Services* section.

> Toggle the Enable button under *General Settings*.

![!Share Enable](/helios4/img/omv/share_enable.png)

> Go to *Shares* tab.

> Click **Add**.

> Choose a Shared Folder that you created previously.

> Choose the Public settings (e.g Guests Allowed).

> Click **Save**

![!Share Add](/helios4/img/omv/share_add.png)

Once done you can see the list of active Shares.

![!Share List](/helios4/img/omv/share_list.png)

!!! info
    Don't forget to apply your settings by clicking **Apply** when the following banner appears.

![!OMV Save Settings](/helios4/img/omv/save_settings.png)

**Now you should be able to access your Share Folders from your laptop / computer connected to your Home network.**


## Accessing Shared Folder (Linux / Ubuntu)

### Using File Manager

Some Linux flavors, like Ubuntu, provide File Manager that supports natively Windows Share Folder discovery and access.

> Open File Manager

> Go to Network

> Click **helios4 - SMB/CIFS**

!!! info
    If your File Manager doesn't find helios4, it can be due that your laptop / computer is not on the same subnet that Helios4. Check your network configuration.


![!Share Network](/helios4/img/omv/share_network.png)

> Click on one of the Share Folders (e.g movie).

> Select *Registered User*.

> Enter Username and Password of the user you created previously (e.g john).

> click **Connect**.

![!Share Credential](/helios4/img/omv/share_credential.png)

Now you should be connected to the Share Folder. Check in the side pane, you should see something like *'movie on helios4.local'* with an Eject icon.

You can start copying over from your laptop / computer files in the Share Folder.

![!Share File](/helios4/img/omv/share_file.png)

You can also try to access as anonymous user which should allow you access the files but not to add / delete files.

> Click the **Eject** icon of the Share Folder.

> Repeat above steps but this time connect as *Anonymous*.

![!Share Anonymous](/helios4/img/omv/share_anonymous.png)

You can repeat the above steps to connect to your other Share Folders.

### Using Terminal

```bash
mount -t cifs //10.10.10.1/movie /mnt -o username=anonymous
```

## Accessing Shared Folder (Windows)

> Open File Explorer.

> Go to Network.
![!Windows Discovery](/helios4/img/omv/windows_discovery.png)

!!! info
    If your File Manager doesn't find helios4, it can be due that your laptop / computer is not on the same subnet that Helios4. Check your network configuration.

> Go to Helios4.

> Right-Click on a Share Folder and click **Map network drive...**.

![!!Windows Access](/helios4/img/omv/windows_access.png)

> Check *Connect using different credentials*.

> Click **Finish**.

![!!Windows Drive](/helios4/img/omv/windows_netdrive.png)

> Enter Username and Password of the user you created previously (e.g john).

> click **OK**.

![!!Windows Credential](/helios4/img/omv/windows_credential.png)

Now you should be connected to the Share Folder. Check in the side pane, you should see something like *'movie (\\\\HELIOS4)'*.

![!Windows Share](/helios4/img/omv/windows_share.png)

You can repeat the above steps to connect to your other Share Folders.
