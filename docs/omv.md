!!! info
    Wiki edition in progress

This is a basic guide to help you setting up Helios4 NAS with [OpenMediaVault](https://www.openmediavault.org/) (**OMV**). OMV offers a large collection of features that we don't cover here. We invite you to look online for the existing OMV guides or go on the [OMV forum](https://forum.openmediavault.org/).

## Connect to OpenMediaVault (OMV) Control Panel

Open your web browser and go to the one of the following addresses :

* http://helios4.local<br>
* http://*xxx.xxx.xxx.xxx* ([How to check Helios4 IP address](/install/#step-6-checkset-ip-address))

**Default credential :**

* Username: admin
* Password: openmediavault

![OMV Login](/img/omv/login.png)
*Login Screen*

![OMV Dashboard](/img/omv/dashboard.png)
*Dashboard View*

## Wipe Disk (Optional)

If you are using HDD which aren't blank or brand new you might need to wipe them first before being able to setup an RAID array.

> Go to **Physical Disks** menu.

> Select an HDD and click **Wipe**.

!!! note
    HDD should be device starting with **/dev/sdX**

![OMV HDD Wipe](/img/omv/disk-wipe1.png)

> Choose **Quick** wipe method.

![OMV HDD Wipe](/img/omv/disk-wipe2.png)

> Repeat this step for each HDD you want to use for your RAID array.


## Create a RAID array

In this guide we chose to create a RAID10 for the following reasons :

- A
- B
- C

You can choose to go for RAID5 or RAID6 but take in consideration that the syncing will take up to 3 times the syncing time of RAID10.

> Go to **Physical Disks** menu.

> Click **Create**.

> Select RAID level and the devices you want to be used for the RAID array.

> Give it a name and press **Create**.


![OMV RAID 10](/img/omv/create-raid10.png)

> You can see the ongoing re-syncing process and get a finish estimated time.

![OMV RAID Syncing](/img/omv/syncing-raid10.png)

!!! important
    While you could carry on with some part of OMV configuration during the RAID re-syncing process, we strongly advice to let this process complete first. You should see the following in the RAID state once re-syncing is complete : **active**.

![OMV RAID Clean](/img/omv/raid10-active.png)


!!! info
    Whenever you change some settings in OMV, the following banner will appear. You can immediately apply the configuration by clicking **Apply** or you can carry on with your configuration and apply the changes at a later stage.
![OMV Save Settings](/img/omv/save_settings.png)



## Create a LVM Logical Volume

*First you need to install OMV LVM Plugin.*

## Format and Mount Volume

## Create User

## Create Shared Folder

## Configure Windows Share (SMB/CIFS)
