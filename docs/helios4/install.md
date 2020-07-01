!!! note
    Go to [Kit Assembly](/helios4/kit/) to find out how to put together your Helios4 NAS

## **What you need before you start.**

**1. microSD Card<br>**
You need a microSD Card UHS-I with a minimum of 8GB. We recommend the following models:

- SanDisk Extreme microSDHC UHS-I Card (32GB)
- SanDisk Extreme PRO microSDHC UHS-I Card (32GB)
- Strontium Nitro MicroSD Card (16GB)
- Samsung microSDHC UHS-I Card EVO Plus (32GB)

![Recommended SDcard](/helios4/img/install/recommended_sdcard.jpg)

You might refer to the [SD Card](/helios4/sdcard/#tested-microsd-card) page to find a compatibility list of SD Card models.

**2. Micro-USB to USB cable<br>**
![USB cable](/helios4/img/install/console_cable.png)

**3. Ethernet cable (cat5/6)<br>**
![Network cable](/helios4/img/install/network_cable.jpg)


## **Step 1** - Download an Helios4 image build

You will need first to download a image build to write on the microSD Card.

Go to [Dowload](/download) and chose one of the latest build.

##  **Step 2** - Writing an image to a microSD Card

You will need to use an image writing tool to install on your microSD Card the image build you have downloaded.

### Under Windows, Mac OS or Linux (via Graphic Interface)

Etcher is a graphical SD card writing tool that works on Mac OS, Linux and Windows, and is the easiest option for most users. Etcher also supports writing images directly from XZ files, without any prerequired decompression. To write your image with Etcher:

- [Download Etcher](http://etcher.io) and install it on your computer.
- Insert the microSD Card inside your SD card reader (microSD to SD adapter might be needed).
- Open Etcher and select from your local storage the Helios4 file you wish to write to the microSD Card.
- Select the microSD Card you wish to write your image to.
- Review your selections and click 'Flash!' to begin writing data to the microSD Card.

![Etcher](/helios4/img/install/etcher_flash.png)

### Under Linux (via Terminal)

```bash
zcat Armbian_20.05.2_Helios4_buster_current_5.4.43.img.gz | pv | dd of=/dev/mmcblkX bs=1M
```

*Replace the filename by the image file name you downloaded.*

!!! note
    /dev/mmcblkX is where the microSD is mapped in your Linux machine, change the 'X' to your corresponding mapped device. If you set /dev/mmcblkX to a wrong device then you might risk erasing a different device than the designated microSD.

##  **Step 3** - Power-up Helios4

**Before powering-up insure :**

1. You inserted the microSD Card that you prepared in the previous step.

2. You connected your computer to the serial port with the Micro-USB to USB cable.

3. You connected Helios4 to your home network with the Ethernet cable.

4. You plugged-in properly the DC power connector before powering-up the AC adapter.

![Connections](/helios4/img/install/connections.png)

**Now you can plug-in / power-up the AC adapter.**

!!! warning
    Always proceed with caution when manipulating 110/220V appliance.

##  **Step 4** - Connect to Helios4 serial console

!!! Important
    For Windows and Mac OS you will need to install the FTDI driver in order to access the USB to serial bridge used by Helios4. You can find the driver [here](https://www.ftdichip.com/Drivers/VCP.htm).

### Under Windows

1. [Download PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) and install it on your computer.

2. Select connection type **serial**.<br>
![Putty connect](/helios4/img/install/putty_config.png)

3. Setup serial port settings (Serial line : **COM1** and Speed : **115200**), then press **'Open'**<br>
![Putty config](/helios4/img/install/putty_connect.png)

!!! note
    If you computer already has a serial port then COM1 might not be the correct serial line to connect to Helios4. Check this [link](https://tnp.uservoice.com/knowledgebase/articles/172101-determining-the-com-port-of-a-usb-to-serial-adapte) to learn how to determine the right COM port.


### Under Linux (via Terminal)

**1.** Install picocom

Use apt-get under Debian/Ubuntu

    $ sudo apt-get install picocom

Use yum under RHEL / CentOS / Fedora Linux

    $ sudo yum install picocom

**2.** Connect to serial with picocom

    $ sudo picocom -b 115200 /dev/ttyUSB0

![Picocom](/helios4/img/install/picocom.png)

To exit picocom do **Ctrl-a** then **Ctrl-x**

!!! note
    Using command _ls -la /dev/ttyUSB*_ you should be able the find the USB to serial bridge device used by Helios4. Under Linux the device will be named **/dev/ttyUSBx**, where **x** is a digit.


### Under Mac OS (via Terminal)

Connect serial using the *screen* command

    $ screen /dev/tty.usbserial-XXXXXXXX 115200 -L

To exit the session do **Ctrl-a** then **Ctrl-k**

!!! note
    Using command _ls -la /dev/tty.usb*_ you should be able the find the USB to serial bridge device used by Helios4. Under Mac OS the device will be named **/dev/tty.usbserial-xxxxxxxx**, where **xxxxxxxx** is some serial number.

## **Step 5** - Log in

!!! note
    You might need to press **Enter** for the login prompt to come up.

**Default credential for Debian image**

```bash
helios4 login: root
Password: 1234
```

You will be prompted to change the root password and then create a new user account.

![First Login](/helios4/img/install/first_login.png)

## **Step 6** - Check/Set IP address

### Check IP address

By default Helios4 will try to obtain an IP address via DHCP. To figure out what is the allocated IP address you will need to type the following command in the console.

```bash
ip addr show dev eth0
```

![Network Config](/helios4/img/install/network_config.png)

Here the IP address of Helios4 is **10.10.10.1**.

### Set IP address

If you wish to manually configure your IP address you can use the **armbian-config** tool.

```bash
armbian-config
```

![Armbian-config](/helios4/img/install/armbian-config.png)

![Armbian-config](/helios4/img/install/armbian-config_network.png)

![Armbian-config](/helios4/img/install/armbian-config_ip-static.png)

![Armbian-config](/helios4/img/install/armbian-config_ip.png)

Press **ESC** till you exit armbian-config tool.

You will have to reboot for the network settings to take effect.
```bash
sudo reboot
```

!!! info
    You can also refer to the following Debian Wiki [Page](https://wiki.debian.org/NetworkConfiguration#Setting_up_an_Ethernet_Interface) for advanced network settings.

## **Step 7** - Connect to Helios4 via SSH

You can now connect by SSH to your Helios4 to carry on with your configuration.

![SSH Login](/helios4/img/install/ssh_login.png)

![Putty SSH](/helios4/img/install/putty_ssh.png)

## **What to do next ?**

After a fresh install, it's always good to update the system with the latest packages.

```bash
sudo apt-get update
sudo apt-get upgrade
```

If you want to install OpenMediaVault, the next-gen network attached storage (NAS) software, refer to the [OMV](/helios4/omv/) page.

If you have assembled an OLED Display as part of your Helios4 setup, it can be the right time to set it up. Refer to the following [section](/helios4/i2c/#sys-oled-application) that will explain you how to install the **sys-oled** application which control the OLED display.

For other software you can use **armbian-config** which provides an easy way to install 3rd party applications. You can also refer to our *Software* section to find tutorials that will help you to setup manually your Helios4.

```bash
sudo armbian-config
```

![!armbian-config Main Menu](/helios4/img/omv/install-1.png)

![!armbian-config Software](/helios4/img/omv/install-2.png)

![!armbian-config Selection](/helios4/img/install/softy.png)
