!!! info
    Wiki edition in progress

!!! note
    Go to [Starter Kit](./kit) to find out how to put together your Helios4 NAS

## **What you need before your start.**

You need any SDcard UHS-I with minimum of 8GB. Ideally Speed Class 3.

We recommend the following models :

- Samsung Evo Pro 16GB
- SanDisk Extreme Pro 16GB

## **Step 1** - Download an Helios4 OS image

You will need first to download an image to write on SD card.

Go to [Dowload](./download) and chose one of the latest build.

##  **Step 2** - Writing an image to an SD card

You will need to use an image writing tool to install the image you have downloaded on your SD card.

### Under Windows, Mac OS or Linux (via Graphic Interface)

Etcher is a graphical SD card writing tool that works on Mac OS, Linux and Windows, and is the easiest option for most users. Etcher also supports writing images directly from the XZ file, without any prerequired decompression. To write your image with Etcher:

- [Download Etcher](http://etcher.io) and install it.
- Connect an SD card reader with the SD card inside.
- Open Etcher and select from your local storage the Helios4 .img.xz file you wish to write to the SD card.
- Select the SD card you wish to write your image to.
- Review your selections and click 'Flash!' to begin writing data to the SD card.


### Under Linux (via CLI)

```bash
$ unxz Helios4_Debian_Jessie_4.4.96.img.xz

$ dd bs=4M if=Helios4_Debian_Jessie_4.4.96.img of=/dev/sdX conv=fsync
```

##  **Step 3** - Power-up Helios4


##  **Step 4** - Connect to Helios4

**Default credential**

```bash
helios4 login: root
Password: 1234
```

You will be prompted to change the root password and then create a standard user account.
