!!! note
    Go to [Kit Assembly](/helios64/kit) to find out how to assembly Helios64.

## **What you need before you start.**

**1. microSD Card<br>**
You need a microSD Card UHS-I with a minimum capacity of 8GB to be able to flash Helios64 images.
![microSD](/helios64/img/install/microsd.jpg)

**2. USB Type-C to Type-A cable<br>**
![Type C to Type A USB cable](/helios64/img/usb/typec_typea_male.jpg)

**3. Ethernet cable (cat5/6)<br>**
![Network cable](/helios4/img/install/network_cable.jpg)


## **Step 1** - Download an Helios64 image build

You will need first to download an image to write on the microSD Card.

Go to [Dowload](/helios64/download) and chose one of the latest build.

!!! note
    Since Armbian 20.05 version, the OS image is compressed in XZ format. If you use balena etcher, you can directly write the XZ compressed image files to the microSD.

##  **Step 2** - Writing an image to a microSD Card

You will need to use an image writing tool to install on your microSD Card the image build you have downloaded.

### Under Windows, Mac OS or Linux (via Graphic Interface)

Etcher is a graphical SD card writing tool that works on Mac OS, Linux and Windows, this is the easiest method for most users. Etcher also supports writing images directly from XZ files, without any prerequired decompression. To write your image with Etcher:

- [Download Etcher](http://etcher.io) and install it on your computer.
- Insert the microSD Card inside your SD card reader (microSD to SD adapter might be needed).
- Open Etcher and select the Helios64 image file from your local storage.
- Select the microSD Card you wish to write your image to.
- Review your selections and click 'Flash!' to begin writing data to the microSD Card.

![Etcher](/helios64/img/install/etcher_flash.png)

### Under Linux (using dd via Terminal)

Since Armbian 20.05 version the provided images is in XZ compression format, therefore we need xz-utils or xz tools to decompress this file.

for Debian-based distribution (Debian/Ubuntu) you can install the utility using following command:
```bash
apt-get install xz-utils
```

in RedHat-based distribution (RHEL / CentOS / Fedora Linux) users can use this command:
```bash
yum install xz
```

after installing the compression tool, you can now decompress the images:
```bash
xz -dk Armbian_20.08.0-trunk_Helios64_buster_current_5.4.55.img.xz
```

finally we can write the images to sdcard using dd:

```bash
sudo dd if=Armbian_20.08.0-trunk_Helios64_buster_current_5.4.55.img of=/dev/sdX bs=4M conv=fsync status=progress
```

*Replace the filename by the image file name you downloaded.*

!!! note
    /dev/sdX is where the microSD is mapped in your Linux machine, change the 'X' to your corresponding mapped device. If you set /dev/sdX to a wrong device then you might risk erasing a hard drive or different device than the designated microSD.

##  **Step 3** - Power-up Helios64

**Before powering-up make sure:**

1. You inserted the prepared microSD Card (already contain OS image).

2. You connected your computer to the serial port with the Type-C to Type-A USB cable.

3. You connected Helios64 to your home network with the Ethernet cable.

4. You plugged-in properly the DC power connector before powering-up the AC adapter.

![Connections](/helios64/img/install/connections.jpg)

**Now you can plug-in the AC adapter and push the power button**

!!! warning
    Always proceed with caution when manipulating 110/220V appliance.

##  **Step 4** - Connect to Helios64 serial console

!!! Important
    Under Windows 10 the FTDI driver will be autodetected, you can use this microsoft default driver to access the USB to serial bridge used by Helios64.

### Under Windows

1. [Download PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) and install it on your computer.

2. Make sure your serial communication device is already detected by system.
![Serial detected](/helios64/img/install/serial-port.png)

2. Select connection type **serial**.<br>
![Putty connect](/helios64/img/install/putty-connect.png)

3. Setup serial port settings (Serial line : **COM3** and Speed : **1500000**), then press **'Open'**<br>
![Putty config](/helios64/img/install/putty-connect2.png)

!!! note
    The serial port detection may vary on different system, please make sure to check the device manager to get the information of correct serial port to connect to Helios64. Check this [link](https://tnp.uservoice.com/knowledgebase/articles/172101-determining-the-com-port-of-a-usb-to-serial-adapte) to learn how to determine the right COM port.


### Under Linux (via Terminal)

**1.** Install picocom

Use apt-get under Debian/Ubuntu

    $ sudo apt-get install picocom

Use yum under RHEL / CentOS / Fedora Linux

    $ sudo yum install picocom

**2.** Connect to serial with picocom

    $ sudo picocom -b 1500000 /dev/ttyUSB0

![Picocom](/helios64/img/install/picocom.png)

To exit picocom do **Ctrl-a** then **q** button in squence

!!! note
    Using command _ls -la /dev/ttyUSB*_ you should be able the find the USB to serial bridge device used by Helios64. Under Linux the device will be named **/dev/ttyUSBx**, where **x** is a digit.


### Under Mac OS (via Terminal)

Connect serial using the *screen* command

    $ screen /dev/tty.usbserial-XXXXXXXX 1500000 -L

To exit the session do **Ctrl-a** then **Ctrl-k**

!!! note
    Using command _ls -la /dev/tty.usb*_ you should be able the find the USB to serial bridge device used by Helios64. Under Mac OS the device will be named **/dev/tty.usbserial-xxxxxxxx**, where **xxxxxxxx** is some serial number.

## **Step 5** - Log in

!!! note
    You might need to press **Enter** for the login prompt to come up.

**Default credential for Debian or Ubuntu image**

```bash
helios4 login: root
Password: 1234
```

You will be prompted to change the root password and then create a new user account.

![First Login](/helios64/img/install/first-boot-userpass.png)

## **Step 6** - Check/Set IP address

### Check IP address

By default Helios64 will try to obtain an IP address via DHCP. To figure out what is the allocated IP address you will need to type the following command in the console.

```bash
ip addr show dev eth0
```

![Network Config](/helios64/img/install/ifconfig.png)

Here the IP address of Helios64 is **10.10.10.73**.

### Set IP address

If you wish to manually configure your IP address you can use the **armbian-config** tool.

```bash
armbian-config
```

![Armbian-config](/helios64/img/install/armbian-config.png)

![Armbian-config](/helios64/img/install/armbian-config-eth-select.png)

![Armbian-config](/helios64/img/install/armbian-config-network.png)

![Armbian-config](/helios64/img/install/armbian-config-ip-static.png)

![Armbian-config](/helios64/img/install/armbian-config-ip-set.png)

Press **ESC** till you exit armbian-config tool.

You will have to reboot for the network settings to take effect.
```bash
sudo reboot
```

!!! info
    You can also refer to the following Debian Wiki [Page](https://wiki.debian.org/NetworkConfiguration#Setting_up_an_Ethernet_Interface) for advanced network settings.

## **Step 7** - Connect to Helios64 via SSH

You can now connect by SSH to your Helios64 to carry on with your configuration.

![SSH Login](/helios64/img/install/ssh_login.png)

![Putty SSH](/helios64/img/install/putty_ssh.png)

## **What to do next ?**

If you want to install OpenMediaVault, the next-gen network attached storage (NAS) software, refer to the [OMV](/helios4/omv) page.

If you have assembled an OLED Display as part of your Helios64 setup, it can be the right time to set it up. Refer to the following [section](/helios4/i2c/#sys-oled-application) that will explain you how to install the **sys-oled** application which control the OLED display.

For other software you can use **armbian-config** which provides an easy way to install 3rd party applications. You can also refer to our *Software* section to find tutorials that will help you to setup manually your Helios64.

```bash
sudo armbian-config
```

![!armbian-config Main Menu](/helios64/img/omv/install-1.png)

![!armbian-config Software](/helios64/img/omv/install-2.png)

![!armbian-config Selection](/helios64/img/omv/install-3.png)

![!armbian-config Selection](/helios64/img/omv/install-4.png)
