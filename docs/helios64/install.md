!!! note
    Go to [Kit Assembly](/helios64/kit) to find out how to assembly Helios64.

## **What you need before you start.**

**1. microSD Card<br>**
You need a microSD Card UHS-I with a minimum capacity of 8GB to be able to flash Helios64 image.

We recommend the following models:

- SanDisk Extreme microSDHC UHS-I Card (32GB)
- SanDisk Extreme PRO microSDHC UHS-I Card (32GB)
- Strontium Nitro MicroSD Card (16GB)
- Samsung microSDHC UHS-I Card EVO Plus (32GB)

![Recommended SDcard](/helios64/img/install/recommended_sdcard.jpg)

**2. USB Type-C to Type-A cable<br>**
![Type C to Type A USB cable](/helios64/img/usb/typec_typea_male.jpg)

**3. Ethernet cable (cat5/6)<br>**
![Network cable](/helios64/img/install/network_cable.jpg)


## **Step 1** - Download an Helios64 image build

You will need first to download an image to write on the microSD Card.

Go to [Dowload](/helios64/download) and chose one of the latest build.

!!! info
    OMV (OpenMediaVault) is only supported on Debian OS.

##  **Step 2** - Writing an image to a microSD Card

You will need to use an image writing tool to install on your microSD Card the image build you have downloaded.

### Under Windows, Mac OS or Linux (via Graphic Interface)

Etcher is a graphical SD card writing tool that works on Mac OS, Linux and Windows, this is the easiest method for most users. Etcher also supports writing images directly from XZ files, without any prerequired decompression. To write your image with Etcher:

- [Download Etcher](https://www.balena.io/etcher/) and install it on your computer.
- Insert the microSD Card inside your SD card reader (microSD to SD adapter might be needed).
- Open Etcher and select the Helios64 image file from your local storage.
- Select the microSD Card you wish to write your image to.
- Review your selections and click 'Flash!' to begin writing data to the microSD Card.

![Etcher](/helios64/img/install/etcher_flash.png)

### Under Linux (using dd via Terminal)

Armbian images are using XZ compression format, therefore we need xz-utils or xz tools to decompress the image first.

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
xz -dk Armbian_20.08.0_Helios64_buster_current_5.7.15.img.xz
```

finally we can write the images to sdcard using dd:

```bash
sudo dd if=Armbian_20.08.0_Helios64_buster_current_5.7.15.img of=/dev/sdX bs=4M conv=fsync status=progress
```

*Replace the filename by the image file name you downloaded.*

!!! note
    /dev/sdX is where the microSD is mapped in your Linux machine, change the 'X' to your corresponding mapped device. If you set /dev/sdX to a wrong device then you might risk erasing a hard drive or different device than the designated microSD.

##  **Step 3** - Wire Helios64

!!! warning
    Always proceed with caution when manipulating 110/220V appliance.

1. Insert the prepared microSD Card.

2. Connect your computer to the serial port with the Type-C to Type-A USB cable.

3. Connect Helios64 to your home network with the Ethernet cable.<br>*Choose LAN2 port if you have 2.5Gb network.*

4. Plug-in the DC power connector. **Don't power-up the Power Adapter yet.**

![Connections with Enclosure](/helios64/img/install/connections_A.png)

If you are using Helios64 without an enclosure:

![Connections without Enclosure](/helios64/img/install/connections_B.png)


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


## **Step 5** - Power-Up Helios64

Now that everything is ready you can plug-in the AC adapter and push the [Power Button](/helios64/button/).

![Enclosure Power ON](/helios64/img/install/power-on_A.png)

If you are using Helios64 without an enclosure:

![Enclosure Power ON](/helios64/img/install/power-on_B.png)

You should see Helios64 boot logs on the Serial Console.

![Boot Output](/helios64/img/install/boot-output.png)

## **Step 6** - Log in

!!! note
    You might need to press **Enter** for the login prompt to come up.

**If system didn't auto logged-in. Default credential for Debian or Ubuntu image**

```bash
helios64 login: root
Password: 1234
```

You will be prompted to change the root password and then create a new user account.

![First Login](/helios64/img/install/first-login.png)

## **Step 7** - Check/Set IP address

### Check IP address

By default Helios64 will try to obtain an IP address via DHCP. To figure out what is the allocated IP address you will need to type the following command in the console.

```bash
ip addr show dev eth0
```

![Network Config](/helios64/img/install/ifconfig.png)

Here the IP address of Helios64 is **10.10.10.1**.

### Set IP address

If you wish to manually configure your IP address you can use the **armbian-config** tool.

```bash
armbian-config
```

Select the *Network* section:

![Armbian-config](/helios64/img/install/armbian-config.png)

Navigate to *IP* to configure your IPv4 address:

![Armbian-config](/helios64/img/install/armbian-config-network.png)

Select the Ethernet interface you want to assign a fixed IPv4 address. In this case we select **eth0** which correspond to LAN port 1:

![Armbian-config](/helios64/img/install/armbian-config-eth-select.png)

Select *Static*:

![Armbian-config](/helios64/img/install/armbian-config-ip-static.png)

Provide the IP Address, Netmask, and Gateway information that you want to assign:

![Armbian-config](/helios64/img/install/armbian-config-ip-set.png)

Press **ESC** till you exit armbian-config tool.

You will have to reboot for the network settings to take effect.
```bash
sudo reboot
```

!!! info
    You can also refer to the following Debian Wiki [Page](https://wiki.debian.org/NetworkConfiguration#Setting_up_an_Ethernet_Interface) for advanced network settings.

## **Step 8** - Connect to Helios64 via SSH

You can now connect by SSH to your Helios64 to carry on with your configuration.

Here is the example when we use linux client:

![SSH Login](/helios64/img/install/ssh_login.png)

You can use putty as the SSH client if you are using windows:

![Putty SSH](/helios64/img/install/putty_ssh.png)

## **What to do next ?**

You can use **armbian-config** which provides an easy way to install 3rd party applications like *OpenMediaVault*, *NextCloud*, *Syncthing*, *Emby* and many more.

Here an example on how to install software OpenMediaVault (OMV) using the armbian-config.

```bash
sudo armbian-config
```

Select *Software* section:

![!armbian-config Main Menu](/helios64/img/omv/install-1.png)

Navigate to *Softy*:

![!armbian-config Software](/helios64/img/omv/install-2.png)

Then choose *OMV*, to install the OpenMediaVault:

![!armbian-config Selection](/helios64/img/omv/install-3.png)

Wait the install process to complete:

![!armbian-config Selection](/helios64/img/omv/install-4.png)
