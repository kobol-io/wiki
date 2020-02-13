## **Step 1** - Download Helios64 OS image

Before we start, you will need to download the Armbian Image for Helios64 build.

Go to [Dowload](/helios64/download) section and chose one of the latest stable build.

!!! note
    Images with .7z extension can be uncompressed by using 7-Zip ([Windows](https://www.7-zip.org/)), Keka (OS X) and 7z (Linux).
On Linux machine 7z can be installed by : apt-get install p7zip-full.

##  **Step 2** - Setup your Helios64 Hardware

Make sure the system in the powered off condition. Plug the USB-C cable from the device to your PC/Mac.
Turn on the Helios64 device while pushing the Recovery Button (see [Hardware Page](/helios64/hardware/overview) for the location of the button).  


##  **Step 3** - Choosing the USB Mass Storage  USB-C Cable

Push the recovery button at least **TBD** seconds to enter the recovery mode, after this the Helios64 board will detected as the USB Mass storage from your PC/Mac.
In this condition, actually the eMMC of the Helios64 board is the one detected as the USB mass storage. From this stage, you can write your image to this USB mass storage.


##  **Step 4** - Writing an image directly to the eMMC via USB-C Cable

In this section we will write the OS image directly to the eMMC storage.
To perform this step, you will need an image writing tool to flash the downloaded image.
We recommend Etcher as the writing tools software, that can be downloaded from [Etcher download pages](https://etcher.download/). In our experience Etcher works in almost every host Operating System.
Aside from this software, built in linux program (command) such as **dd** also can be used as an alternative to Etcher.

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
7z e Armbian_5.90_Helios4_Debian_buster_next_4.19.59.7z

sudo dd bs=4M if=Armbian_5.90_Helios4_Debian_buster_next_4.19.59.img of=/dev/sdX conv=fsync
```

*Replace the filename by the image file name you downloaded.*

!!! note
    /dev/sdX is where the microSD is mapped in your Linux machine, change the 'X' to your corresponding mapped device. If you set /dev/sdX to a wrong device then you might risk erasing a hard drive or different device than the designated microSD.

##  **Step 3** - Power-up Helios64

**Before powering-up up your device, make sure following requirement are statisfied :**

1. The prepared microSD Card is already inserted to the board 

2. The USB-C Cable from your Helios64 board already connected to USB-C in your PC/Mac.

3. The Ethernet cable from your home network is already connected to either 1 Gbps Ethernet or 2.5Gbps Ethernet port.

4. The AC Adapter cable already properly connected to your Helios64 device before powering-up the power supply.

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
![Putty connect](/helios64/img/install/putty_config.png)

3. Setup serial port settings (Serial line : **COM1** and Speed : **1500000**), then press **'Open'**<br>
![Putty config](/helios64/img/install/putty_connect.png)

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

!!! note
    Helios64 use 1.5Mbps baut rate for the serial connection, picocom Ver. 1.7 will not work with this configuration. We recommend **picocom Ver 2.2** or later for Helios64 device.
  
To exit picocom do **Ctrl-a-q**

!!! note
    Using command _ls -la /dev/ttyUSB*_ you should be able the find the USB to serial bridge device used by Helios64. Under Linux the device will be named **/dev/ttyUSBx**, where **x** is a digit.


### Under Mac OS (via Terminal)

Connect serial using the *screen* command

    $ screen /dev/tty.usbserial-XXXXXXXX 1500000 -L

To exit the session do **Ctrl-a** then **Ctrl-k**

!!! note
    Using command _ls -la /dev/tty.usb*_ you should be able the find the USB to serial bridge device used by Helios4. Under Mac OS the device will be named **/dev/tty.usbserial-xxxxxxxx**, where **xxxxxxxx** is some serial number.

## **Step 5** - Log in

!!! note
    You might need to press **Enter** for the login prompt to come up.

**Default credential for Debian image**

```bash
helios64 login: root
Password: 1234
```

You will be prompted to change the root password and then create a new user account.

![First Login](/helios4/img/install/first_login.png)

## **Step 6** - Check/Set IP address

### Check IP address

By default Helios64 will try to obtain an IP address via DHCP. To figure out what is the allocated IP address you will need to type the following command in the console.

```bash
ip addr show dev eth0
```

![Network Config](/helios4/img/install/network_config.png)

Here the IP address of Helios64 is **10.10.10.1**.

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

## **Step 7** - Connect to Helios64 via SSH

You can now connect by SSH to your Helios4 to carry on with your configuration.

![SSH Login](/helios4/img/install/ssh_login.png)

![Putty SSH](/helios4/img/install/putty_ssh.png)

## **What to do next ?**

If you want to install OpenMediaVault, the next-gen network attached storage (NAS) software, refer to the [OMV](/helios4/omv) page.

If you have assembled an OLED Display as part of your Helios64 setup, it can be the right time to set it up. Refer to the following [section](/helios4/i2c/#sys-oled-application) that will explain you how to install the **sys-oled** application which control the OLED display.

For other software you can use **armbian-config** which provides an easy way to install 3rd party applications. You can also refer to our *Software* section to find tutorials that will help you to setup manually your Helios4.

```bash
sudo armbian-config
```

![!armbian-config Main Menu](/helios4/img/omv/install-1.png)

![!armbian-config Software](/helios4/img/omv/install-2.png)

![!armbian-config Selection](/helios4/img/install/softy.png)
