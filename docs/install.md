### Work in progress

!!! note
    Go to [Starter Kit](./kit) to find out how to put together your Helios4 NAS


## **Step 1** - Download an Helios4 OS image

You will need first to download an image to write on SD card.

Go to [Dowload](./download) and chose one of the latest build.

##  **Step 2** - Writing an image to an SD card

You will need to use an image writing tool to install the image you have downloaded on your SD card.

### Under Windows, Mac OS or Linux (via Graphic Interface)

Etcher is a graphical SD card writing tool that works on Mac OS, Linux and Windows, and is the easiest option for most users. Etcher also supports writing images directly from the zip file, without any unzipping required. To write your image with Etcher:

- [Download Etcher](http://etcher.io) and install it.
- Connect an SD card reader with the SD card inside.
- Open Etcher and select from your hard drive the Helios4 .img.xz file you wish to write to the SD card.
- Select the SD card you wish to write your image to.
- Review your selections and click 'Flash!' to begin writing data to the SD card.


### Under Linux (via CLI)

```bash
$ unxz Helios4_Debian_Jessie_4.4.96.img.xz

$ dd bs=4M if=Helios4_Debian_Jessie_4.4.96.img of=/dev/sdX conv=fsync
```

##  **Step 3** - Power-up Helios4


##  **Step 4** - Connect to Helios4
