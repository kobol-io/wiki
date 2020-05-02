Syncloud is an Open Source turn-key solution providing a simple interface similar to mobile App Store to allow users to run and manage popular services like Nextcloud, Rocket.Chat and more without any special technical knowledge.

## Download Syncloud

You can download latest Syncloud release for Helios4 and other devices [here](https://github.com/syncloud/platform/wiki).

## Prepare microSD Card

Refer to the [Install](/helios4/install/) page for instructions on how to prepare your microSD card and how to start and connect to your Helios4.

## Activate Syncloud

First you will need to create an account at [syncloud.it](http://syncloud.it/register.html).

![Syncloud Registration](/helios4/img/syncloud/registration.png)

![Syncloud Add Device](/helios4/img/syncloud/add_device.png)

Once it's done you can perform the activation of your Helios4 device by one of the following two methods:

- web page
- mobile app

### Via Web Page

Open your browser and connect to Helios4 on port 81 (e.g http://10.10.10.1:81)

Fill the form and press *Activate*.

![Syncloud Activation](/helios4/img/syncloud/activation.png)

### Via Mobile App
Install Syncloud app on your smartphone and use it to find and activate your Syncloud device. Syncloud app is simple and intuitive, watch [this demo video](https://www.youtube.com/watch?v=EXJFvWeQw_s).

[![Syncloud Android](/helios4/img/syncloud/play_market.png)](https://play.google.com/store/apps/details?id=org.syncloud.android)

[![Syncloud IOS](/helios4/img/syncloud/app_store.png)](https://itunes.apple.com/app/id1031784126)


## Configure storage

!!! note
    You might want first to setup your RAID array before configuring the storage in Syncloud. Refer to the following [Mdadm](/helios4/mdadm/) page for guideline on how to setup a RAID array. The credentials to connect via SSH to Helios4 are described [here](/helios4/syncloud/#additional-information).

First thing you will need to do is to activate the storage you want to use.

Go to *Settings > Storage*

![Syncloud Storage](/helios4/img/syncloud/storage_page.png)

Toggle the activation switch(es) to add storage device(s).

You should also press *Extend* in order to expand the main partition on your microSD card.

![Syncloud Add Storage](/helios4/img/syncloud/storage_add.png)


## Install Application

Go to *App Center* and click on the application you want to install.

![Syncloud Applications](/helios4/img/syncloud/applications.png)

Press *Install*. You can wait for the process to finish or go back to *App Center* in order to install another application.

![Syncloud App Install](/helios4/img/syncloud/app_installation.png)



## Access Application

Installed applications will appear on the *Apps* dashboard. Simply click on an application to access it.

!!! Important
    Default User and Password for each application will the be the one you setup in device credentials during activation.

![Syncloud Dashboard](/helios4/img/syncloud/dashboard.png)



## Additional Information

**Default SSH credential for Syncloud image**

```bash
helios4 login: root
Password: syncloud
```

After Syncloud activation, your root password will become the one you setup in device credentials.

For more information refer to [Syncloud wiki](https://github.com/syncloud/platform/wiki).
