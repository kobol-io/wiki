## Latest OS Images

### Debian 9 - Stretch (by [Armbian](https://www.armbian.com/helios4/))

[![Debian Stretch](/img/os/debian.png)](https://dl.armbian.com/helios4/archive/Armbian_5.75_Helios4_Debian_stretch_next_4.14.98.7z)<br>
*MD5SUM : 94939b8ebcbc25ee559bf184d8c607ef<br>
Build date : 10/02/2019<br>
Size : 258 MB<br>*
[Direct Download](https://dl.armbian.com/helios4/archive/Armbian_5.75_Helios4_Debian_stretch_next_4.14.98.7z) - [Torrent Download](https://dl.armbian.com/torrent/Armbian_5.75_Helios4_Debian_stretch_next_4.14.98.7z.torrent)

!!! note
    OMV4 (OpenMediaVault 4) can be installed with the **armbian-config** tool as explained [here](/omv/#install-openmediavault).

### Ubuntu 18.04 - Bionic (by [Armbian](https://www.armbian.com/helios4/))

[![Ubuntu Bionic](/img/os/ubuntu.png)](https://dl.armbian.com/helios4/archive/Armbian_5.75_Helios4_Ubuntu_bionic_next_4.14.98.7z)<br>
*MD5SUM : d70b2d51b29e6729c33bbec90825f47a<br>
Build date : 10/02/2019<br>
Size : 193 MB<br>*
[Direct Download](https://dl.armbian.com/helios4/archive/Armbian_5.75_Helios4_Ubuntu_bionic_next_4.14.98.7z) [Torrent Download](https://dl.armbian.com/torrent/Armbian_5.75_Helios4_Ubuntu_bionic_next_4.14.98.7z.torrent)


### Syncloud

[![Syncloud](/img/os/syncloud.png)](https://github.com/syncloud/platform/wiki)

Check their [download page](https://github.com/syncloud/platform/wiki) for latest image.


## Known Issues / Limitations

- SDcard High Speed timing have compatibility issue with some brands.

    **Temporary workaround :** Disable UHS option/support.

    *Can be manually enable, refer to the following [page](/sdcard).*

- During SATA heavy load, accessing SPI NOR Flash will generate ATA errors.

    **Temporary workaround :** Disable SPI NOR flash.

    *Can be manually enable, refer to the following [page](/spi).*

- Wake-on-LAN is not yet implemented.

## Image List

!!! note
    7Z archives can be uncompressed with 7-Zip on Windows, Keka on OS X and 7z on Linux (apt-get install p7zip-full). XZ archives and RAW images can be directly written to microSD card with Etcher (all OS).

Filename | Download | MD5
---------|----------|----
**Armbian_5.75_Helios4_Debian_stretch_next_4.14.98.7z**<br>Armbian 5.75 Debian 9 Stretch (Kernel 4.14.98)<br>Build date : 10/02/2019<br>Size : 258 MB|[Download](https://dl.armbian.com/helios4/archive/Armbian_5.75_Helios4_Debian_stretch_next_4.14.98.7z)|94939b8ebcbc25ee559bf184d8c607ef
**Armbian_5.75_Helios4_Ubuntu_bionic_next_4.14.98.7z**<br>Armbian 5.75 Ubuntu 18.04 Bionic (Kernel 4.14.98)<br>Build date : 10/02/2019<br>Size : 193 MB|[Download](https://dl.armbian.com/helios4/archive/Armbian_5.75_Helios4_Ubuntu_bionic_next_4.14.98.7z)|d70b2d51b29e6729c33bbec90825f47a
**Armbian_5.72_Helios4_Debian_stretch_next_4.14.94.7z**<br>Armbian 5.72 Debian 9 Stretch (Kernel 4.14.94)<br>Build date : 20/01/2019<br>Size : 260 MB|[Download](https://dl.armbian.com/helios4/archive/Armbian_5.72_Helios4_Debian_stretch_next_4.14.94.7z)|c4b5973931acde6e070b88bdfb32957c
**Armbian_5.72_Helios4_Ubuntu_bionic_next_4.14.94.7z**<br>Armbian 5.72 Ubuntu 18.04 Bionic (Kernel 4.14.94)<br>Build date : 20/01/2019<br>Size : 192 MB|[Download](https://dl.armbian.com/helios4/archive/Armbian_5.72_Helios4_Ubuntu_bionic_next_4.14.94.7z)|e372bd132de296228ad1a2289d163fa4
**Armbian_5.68_Helios4_Debian_stretch_next_4.14.88.img.xz**<br>Armbian 5.68 Debian 9 Stretch (Kernel 4.14.88)<br>Build date : 14/12/2018<br>Size : 242 MB|[Download](https://cdn.kobol.io/files/Armbian_5.68_Helios4_Debian_stretch_next_4.14.88.img.xz)|a32a42f694c1aef3ebd8e217be5932e3
**Armbian_5.68_Helios4_Ubuntu_bionic_next_4.14.88.img.xz**<br>Armbian 5.68 Ubuntu 18.04 Bionic (Kernel 4.14.88)<br>Build date : 14/12/2018<br>Size : 183 MB|[Download](https://cdn.kobol.io/files/Armbian_5.68_Helios4_Ubuntu_bionic_next_4.14.88.img.xz)|125735c9ebd88a91cf4fabd36ea903af
**Armbian_5.67_Helios4_Debian_stretch_next_4.14.83.7z**<br>Armbian 5.67 Debian 9 Stretch (Kernel 4.14.83)<br>Build date : 26/11/2018<br>Size : 262 MB|[Download](https://dl.armbian.com/helios4/archive/Armbian_5.67_Helios4_Debian_stretch_next_4.14.83.7z)|56bf66e135ee218e715e72741c14737e
**Armbian_5.67_Helios4_Ubuntu_bionic_next_4.14.83.7z**<br>Armbian 5.67 Ubuntu 18.04 Bionic (Kernel 4.14.83)<br>Build date : 26/11/2018<br>Size : 199 MB|[Download](https://dl.armbian.com/helios4/archive/Armbian_5.67_Helios4_Ubuntu_bionic_next_4.14.83.7z)|d31049b4965363d935e81b94a1af89f0

## Image Archives (Old Images)

!!! warning
    Even though you can use those images, they are now obsoletes for the following reasons :

    * Debian 8 Jessie is End-Of-Life,
    * OpenMediaVault 3.X is End-Of-Life,
    * No more Helios4 support effort on Kernel 4.4.

Filename | Download | MD5
---------|----------|----
**Armbian_Helios4_Debian_Jessie_4.14.20-OMV_3.0.97.img.xz**<br>Debian 8 Jessie (Kernel 4.14.20) with OMV 3.0.97<br>Build date : 17/02/2018<br>Size : 259 MB|[Download](https://cdn.kobol.io/files/Armbian_Helios4_Debian_Jessie_4.14.20-OMV_3.0.97.img.xz)|963af770df27c351a84622bcfc90617a
**Armbian_Helios4_Debian_Jessie_4.4.112-OMV_3.0.96.img.xz**<br>Debian 8 Jessie (Kernel 4.4.112) with OMV 3.0.96<br>Build date : 05/02/2018<br>Size : 275 MB|[Download](https://cdn.kobol.io/files/Armbian_Helios4_Debian_Jessie_4.4.112-OMV_3.0.96.img.xz)|45425c2a16f8f3014275046b22010f82
**Armbian_Helios4_Debian_Jessie_4.4.112.img.xz**<br>Debian 8 Jessie (Kernel 4.4.112)<br>Build date : 05/02/2018<br>Size : 202 MB|[Download](https://cdn.kobol.io/files/Armbian_Helios4_Debian_Jessie_4.4.112.img.xz)|dd6f5ea6e9ac80e4f379d619b71ef1e8

**Default credential for OpenMediaVault image**

```bash
helios4 login: root
Password: openmediavault
```
