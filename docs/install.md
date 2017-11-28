!!! info
    Wiki edition in progress

!!! note
    Go to [Kit Assembly](./kit) to find out how to put together your Helios4 NAS

## **What you need before you start.**

**1. microSD Card<br>**
You need a microSD Card UHS-I with a minimum of 8GB. Ideally Speed Class 3.<br>
We recommend the following models:<br>
\- Samsung Evo Pro+ 32GB<br>
\- SanDisk Extreme Pro 32GB<br>
![Recommended SDcard](/img/install/recommended_sdcard.jpg)

**2. Micro-USB to USB cable<br>**
![USB cable](/img/install/console_cable.png)

**3. Ethernet cable (cat5/6)<br>**
![Network cable](/img/install/network_cable.jpg)


## **Step 1** - Download an Helios4 build image

You will need first to download a build image to write on the microSD Card.

Go to [Dowload](/download) and chose one of the latest build.

##  **Step 2** - Writing an image to a microSD Card

You will need to use an image writing tool to install on your microSD Card the build image you have downloaded.

### Under Windows, Mac OS or Linux (via Graphic Interface)

Etcher is a graphical SD card writing tool that works on Mac OS, Linux and Windows, and is the easiest option for most users. Etcher also supports writing images directly from XZ files, without any prerequired decompression. To write your image with Etcher:

- [Download Etcher](http://etcher.io) and install it on your computer.
- Insert the microSD Card inside your SD card reader (microSD to SD adapter might be needed).
- Open Etcher and select from your local storage the Helios4 .img.xz file you wish to write to the microSD Card.
- Select the microSD Card you wish to write your image to.
- Review your selections and click 'Flash!' to begin writing data to the microSD Card.

![Etcher](/img/install/etcher_flash.png)

### Under Linux (via CLI)

```bash
$ unxz Helios4_Debian_Jessie_4.4.96.img.xz

$ dd bs=4M if=Helios4_Debian_Jessie_4.4.96.img of=/dev/sdX conv=fsync
```

##  **Step 3** - Power-up Helios4

**Before powering-up insure :**

1. You inserted the microSD Card that you prepared in the previous step.

2. You connected your computer to the serial port with the Micro-USB to USB cable.

3. You connected Helios4 to your home network with the Ethernet cable.

4. You plugged-in properly the DC power connector before powering-up the AC adapter.

![Connections](/img/install/connections.png)

**Now you can plug-in / power-up the AC adapter.**

##  **Step 4** - Connect to Helios4 serial console

### Under Windows

1. [Download PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) and install it on your computer.

2. Setup serial port settings (Speed : **115200** and Flow control : **None**).<br>
![Putty config](/img/install/putty_config.png)

3. Select **serial** and click 'Open'.<br>
![Putty connect](/img/install/putty_connect.png)

!!! note
    If you computer already has a serial port then COM1 might not be the correct serial line to connect to Helios4. Check this [link](https://tnp.uservoice.com/knowledgebase/articles/172101-determining-the-com-port-of-a-usb-to-serial-adapte) to learn how to determine the right COM port.

### Under Linux (via CLI)

1. Install and launch minicom
> $ sudo apt-get install minicom<br>
> $ sudo minicom -D /dev/ttyUSB0 -b 115200

2. Setup serial port settings<br>
press **CTRL-A O**, then go to menu 'Serial port setup'.
![Minicom config](/img/install/minicom_config1.png)

3. Disable Hardware Flow control<br>
press **F**, then press **ESC** twice.
![Minicom config](/img/install/minicom_config2.png)


## **Step 5** - Log in

!!! note
    You might need to press enter for the login prompt to come up.

**Default credential for Debian image**

```bash
helios4 login: root
Password: 1234
```

You will be prompted to change the root password and then create a new user account.

**Default credential for OpenMediaVault image**

```bash
helios4 login: root
Password: openmediavault
```

You will be prompted to change the root password.

![First Login](/img/install/first_login.png)

## **Step 6** - Check/Set IP address

By default Helios4 will try to obtain an IP address via DHCP. To figure out what is the allocated IP address you will need to type the following command in the console.

```bash
$ ifconfig eth0
```

![Network Config](/img/install/network_config.png)

Here the IP address of Helios4 is **10.10.10.1**.

If you wish to manually configure your IP address refer to the following Debian Wiki [Page](https://wiki.debian.org/NetworkConfiguration#Setting_up_an_Ethernet_Interface).

!!! note
    Openmediavault comes with **mDNS** server (Avahi daemon). Therefore if your desktop/laptop runs a mDNS client you can reach the board via the following hostname address : **helios4.local**

## **What to do next ?**

**If you have installed an OpenMediaVault image, refer to the [OMV page](/omv) for further instructions.**

Otherwise you can now connect by SSH to your Helios4 to carry on with your manual configuration.

![SSH Login](/img/install/ssh_login.png)
