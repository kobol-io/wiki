Nextcloud is an open-source software suite that allows users to store their data such as files, contacts, calendars, news feed, TODO lists and much more, on their personal servers. It is using standard protocols such as webdavm, carddav and caldav. It also provides client applications so users can easily manage and synchronize their data among Linux, MacOS, Windows platforms and smart phones, which makes Nextcloud a great free alternative to proprietary cloud services such as Dropbox, Google Drive, iCloud, etc…

In this tutorial we will install and configure Nextcloud 16 on a Debian 9 (Stretch) and 10 (Buster).

## Step 0 - Requirements

* You should have Debian 9 (Stretch) or Debian 10 (Buster) running on your Helios4. Refer to [Install](/install) page for instructions.

* Under Debian 9 (Stretch) you will need first to add *deb.sury.org* repo in order to get access to PHP 7.3 packages.

```
wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
echo "deb https://packages.sury.org/php/ stretch main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt-get update
```

* You should have setup your storage. This guide will assume you have setup a RAID array mounted to **/mnt/md0**. Refer to [Mdadm](/mdadm) page for guideline on how to setup a RAID array.

## Step 1 - Install Apache2

A web server is required to run Nextcloud, in this tutorial we will use Apache2. Run the following command to install Apache on your VPS

    sudo apt install apache2

## Step 2 - Install PHP

You need to install PHP 7.3 and the required modules for NextCloud.

    sudo apt-get install php7.3 libapache2-mod-php7.3 php7.3-common php7.3-gd php7.3-json php7.3-mysql php7.3-curl php7.3-mbstring php7.3-intl php-imagick php7.3-xml php7.3-zip php7.3-opcache

## Step 3 - Install and Configure MariaDB

Next, we will install MariaDB.

    sudo apt-get install mariadb-server

Then run the *mysql_secure_installation* post-installation script to harden the security of your MariaDB server.

    sudo mysql_secure_installation

You can answer as follow:

    Set root password? [Y/n] N
    Remove anonymous users? [Y/n] Y
    Disallow root login remotely? [Y/n] Y
    Remove test database and access to it? [Y/n] Y
    Reload privilege tables now? [Y/n] Y

Now, login to the MariaDB server as user root and create a new user and database for Nextcloud.

```bash
sudo mysql -u root -p
```

    MariaDB [(none)]> CREATE DATABASE nextcloud;
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud_user'@'localhost' IDENTIFIED BY 'PASSWORD';
    MariaDB [(none)]> FLUSH PRIVILEGES;
    MariaDB [(none)]> exit;

Don’t forget to replace *‘PASSWORD’* with an actual strong password. Combination of letters and numbers and minimum 10 characters long is recommended.

## Step 4 - Download and install Nextcloud

Go to Nextcloud’s official website and download Nextcloud 16 to your Helios4. Currently latest stable version is Nextcould 16.

    wget https://download.nextcloud.com/server/releases/nextcloud-16.0.3.zip

Extract the downloaded ZIP archive in a directory Apache will have access to, and change the ownership of the nextcloud directory to the web server user.

    sudo unzip nextcloud-16.0.3.zip -d /mnt/md0
    sudo chown -R www-data:www-data /mnt/md0/nextcloud/

Once all Nextcloud prerequisites are fulfilled, we can complete the installation through the command line. Change the current working directory

    cd /mnt/md0/nextcloud

and execute the following command as the web server user:

    sudo -u www-data php occ  maintenance:install --database "mysql" --database-name "nextcloud"  --database-user "nextcloud_user" --database-pass "PASSWORD" --admin-user "admin" --admin-pass "PASSWORD"

Use the database information we created above and set a strong password for the Nextcloud ‘admin’ user.

If the installation is successful you will get the following output

    Nextcloud was successfully installed

### Update PHP settings

Some of the default PHP settings for Apache2 need to be updated in order to meet Nextcloud requirements.


    sudo nano /etc/php/7.3/apache2/php.ini


Update the following values

* memory_limit = 512M
* upload_max_filesize = 1G

### Install PHP APCu

PHP APCu provides data caching that can be used to accelerate the performance of a PHP application such as NextCloud.

    sudo apt-get install php-apcu

Edit the Nextcloud config.php file

```bash
sudo nano config/config.php
```

Add the following line

    'memcache.local' => '\OC\Memcache\APCu',

### Update Apache configuration

In order to allow Apache to access the location where you installed Nextcloud you need to edit /etc/apache2/apach2.conf.

```bash
sudo nano /etc/apache2/apache2.conf
```

Append the following at the bottom of the file:

    # Allow access to /mnt/md0/nextcloud
    <Directory /mnt/md0/nextcloud>
            Options Indexes FollowSymLinks
            AllowOverride None
            Require all granted
    </Directory>  

### Create Apache Virtual Host

!!! important
    Here we are assuming you have your own domain name or your are using a Dynamic DNS service. We recommend [Dynu.com](https://wwww.dynu.com) service which provides free DDNS service.

    They also provide a guideline [here](https://www.dynu.com/DynamicDNS/IPUpdateClient/DDClient) on how to setup **ddclient** tool on Debian to automatically update your DDNS record.

If you want to be able to access Nextcloud with a domain name, you will have to create a new virtual host. For this tutorial we use **mysubdomain.dynu.net** as an example, so don't forget to replace it with your domain name.

Create the following file:

```bash
sudo nano /etc/apache2/sites-available/mysubdomain.dynu.net.conf
```

Copy the following:

    <VirtualHost *:80>

     DocumentRoot /mnt/md0/nextcloud
     ServerName mysubdomain.dynu.net

     Alias /nextcloud “/mnt/md0/nextcloud/”

     <Directory /mnt/md0/nextcloud>
      Options +FollowSymlinks
      AllowOverride All

      <IfModule mod_dav.c>
       Dav off
      </IfModule>

      SetEnv HOME /mnt/md0/nextcloud
      SetEnv HTTP_HOME /mnt/md0/nextcloud
     </Directory>

     ErrorLog /var/log/apache2/nextcloud-error_log
     CustomLog /var/log/apache2/nextcloud-access_log common

    </VirtualHost>

Save the file and enable the newly created virtual host

    sudo a2ensite mysubdomain.dynu.net.conf

To activate the new configuration, you need to reload Apache2

    sudo systemctl restart apache2


Edit the Nextcloud config.php file and add mysubdomain.dynu.net as a trusted domain

```bash
sudo nano config/config.php
```

Edit the following section

    'trusted_domains' =>
      array (
        0 => 'localhost',
        1 => 'mysubdomain.dynu.net',
      ),


With this step the Nextcloud 16 installation is completed. You can now visit http://mysubdomain.dynu.net and login to your Nextcloud instance using the credentials used in the installation command above.

![NextCloud Login Page](/img/nextcloud/login.png)

Log in with user **admin** and the password you set up previously.

## Step 5 - Install and Configure Let's Encrypt (HTTPS)

Finally it is a must to setup HTTPS for your nextcloud install. For that we will use **Let's Encrypt** certificate facility and the available tool **Certbot** to automatically install and configure your certificate.

```bash
sudo apt-get install python-certbot-apache

sudo certbot --authenticator webroot --installer apache
```

Just follow the wizard as shown below:

    Saving debug log to /var/log/letsencrypt/letsencrypt.log

    Which names would you like to activate HTTPS for?
    -------------------------------------------------------------------------------
    1: mysubdomain.dynu.net
    -------------------------------------------------------------------------------
    Select the appropriate numbers separated by commas and/or spaces, or leave input
    blank to select all options shown (Enter 'c' to cancel):
    Enter email address (used for urgent renewal and security notices) (Enter 'c' to
    cancel):me@mymail.com

    -------------------------------------------------------------------------------
    Please read the Terms of Service at
    https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf. You must
    agree in order to register with the ACME server at
    https://acme-v01.api.letsencrypt.org/directory
    -------------------------------------------------------------------------------
    (A)gree/(C)ancel: A
    Obtaining a new certificate
    Performing the following challenges:
    http-01 challenge for mysubdomain.dynu.net

    Select the webroot for mysubdomain.dynu.net:
    -------------------------------------------------------------------------------
    1: Enter a new webroot
    -------------------------------------------------------------------------------
    Press 1 [enter] to confirm the selection (press 'c' to cancel): 1
    Input the webroot for mysubdomain.dynu.net: (Enter 'c' to cancel):/mnt/md0/nextcloud
    Waiting for verification...
    Cleaning up challenges
    Generating key (2048 bits): /etc/letsencrypt/keys/0000_key-certbot.pem
    Creating CSR: /etc/letsencrypt/csr/0000_csr-certbot.pem
    Created an SSL vhost at /etc/apache2/sites-available/mysubdomain.dynu.net-le-ssl.conf
    Enabled Apache socache_shmcb module
    Enabled Apache ssl module
    Deploying Certificate to VirtualHost /etc/apache2/sites-available/mysubdomain.dynu.net-le-ssl.conf
    Enabling available site: /etc/apache2/sites-available/mysubdomain.dynu.net-le-ssl.conf

    Please choose whether HTTPS access is required or optional.
    -------------------------------------------------------------------------------
    1: Easy - Allow both HTTP and HTTPS access to these sites
    2: Secure - Make all requests redirect to secure HTTPS access
    -------------------------------------------------------------------------------
    Select the appropriate number [1-2] then [enter] (press 'c' to cancel): 2
    Enabled Apache rewrite module
    Redirecting vhost in /etc/apache2/sites-available/mysubdomain.dynu.net.conf to ssl vhost in /etc/apache2/sites-available/mysubdomain.dynu.net-le-ssl.conf

    -------------------------------------------------------------------------------
    Congratulations! You have successfully enabled https://mysubdomain.dynu.net


![!NextCloud Dashboard](/img/nextcloud/dashboard.png)

*Tuto Source: [link1](https://www.rosehosting.com/blog/how-to-install-nextcloud-13-on-debian-9/) [link2](https://help.nextcloud.com/t/resolved-nextcloud-on-debian-jessie-access-forbidden/4083/3)*
