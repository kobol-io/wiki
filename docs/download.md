## Latest OS Images

### Debian 9 - Stretch (by [Armbian](https://www.armbian.com/helios4/))

[![Debian Stretch](/img/os/debian.png)](https://cdn.kobol.io/files/Armbian_5.68_Helios4_Debian_stretch_next_4.14.88.img.xz)<br>
*MD5SUM : a32a42f694c1aef3ebd8e217be5932e3<br>
Build date : 14/12/2018<br>
Size : 242 MB<br>*
[Direct Download](https://cdn.kobol.io/files/Armbian_5.68_Helios4_Debian_stretch_next_4.14.88.img.xz)

!!! note
    OMV4 (OpenMediaVault 4) can be installed with the **armbian-config** tool as explained [here](/omv/#install-openmediavault).

### Ubuntu 18.04 - Bionic (by [Armbian](https://www.armbian.com/helios4/))

[![Ubuntu Bionic](/img/os/ubuntu.png)](https://cdn.kobol.io/files/Armbian_5.68_Helios4_Ubuntu_bionic_next_4.14.88.img.xz)<br>
*MD5SUM : 125735c9ebd88a91cf4fabd36ea903af<br>
Build date : 14/12/2018<br>
Size : 183 MB<br>*
[Direct Download](https://cdn.kobol.io/files/Armbian_5.68_Helios4_Ubuntu_bionic_next_4.14.88.img.xz)


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
**Armbian_5.68_Helios4_Debian_stretch_next_4.14.88.img.xz**<br>Armbian Debian 9 Stretch (Kernel 4.14.88)<br>Build date : 14/12/2018<br>Size : 242 MB|[Download](https://cdn.kobol.io/files/Armbian_5.68_Helios4_Debian_stretch_next_4.14.88.img.xz)|a32a42f694c1aef3ebd8e217be5932e3
**Armbian_5.68_Helios4_Ubuntu_bionic_next_4.14.88.img.zx**<br>Armbian Ubuntu 18.04 Bionic (Kernel 4.14.88)<br>Build date : 14/12/2018<br>Size : 183 MB|[Download](https://cdn.kobol.io/files/Armbian_5.68_Helios4_Ubuntu_bionic_next_4.14.88.img.xz)|125735c9ebd88a91cf4fabd36ea903af
**Armbian_5.67_Helios4_Debian_stretch_next_4.14.83.7z**<br>Armbian Debian 9 Stretch (Kernel 4.14.83)<br>Build date : 26/11/2018<br>Size : 262 MB|[Download](https://dl.armbian.com/helios4/archive/Armbian_5.67_Helios4_Debian_stretch_next_4.14.83.7z)|56bf66e135ee218e715e72741c14737e
**Armbian_5.67_Helios4_Ubuntu_bionic_next_4.14.83.7z**<br>Armbian Ubuntu 18.04 Bionic (Kernel 4.14.83)<br>Build date : 26/11/2018<br>Size : 199 MB|[Download](https://dl.armbian.com/helios4/archive/Armbian_5.67_Helios4_Ubuntu_bionic_next_4.14.83.7z)|d31049b4965363d935e81b94a1af89f0
**Armbian_5.64_Helios4_Debian_stretch_next_4.14.74.7z**<br>Armbian Debian 9 Stretch (Kernel 4.14.74)<br>Build date : 09/10/2018<br>Size : 256 MB|[Download](https://dl.armbian.com/helios4/archive/Armbian_5.64_Helios4_Debian_stretch_next_4.14.74.7z)|a6736f5352ebc0a4c2da2a149963412c
**Armbian_5.64_Helios4_Ubuntu_bionic_next_4.14.74.7z**<br>Armbian Ubuntu 18.04 Bionic (Kernel 4.14.74)<br>Build date : 09/10/2018<br>Size : 191 MB|[Download](https://dl.armbian.com/helios4/archive/Armbian_5.64_Helios4_Ubuntu_bionic_next_4.14.74.7z)|d9a054f9b2eadf7a21f7df7719259b3b
**Armbian_5.59_Helios4_Debian_stretch_next_4.14.66.7z**<br>Armbian Debian 9 Stretch (Kernel 4.14.66)<br>Build date : 22/08/2018<br>Size : 253 MB|[Download](https://dl.armbian.com/helios4/archive/Armbian_5.59_Helios4_Debian_stretch_next_4.14.66.7z)|75a0647bfae55a0a7accb9b804ca80ab
**Armbian_5.59_Helios4_Ubuntu_bionic_next_4.14.66.7z**<br>Armbian Ubuntu 18.04 Bionic (Kernel 4.14.66)<br>Build date : 22/08/2018<br>Size : 191 MB|[Download](https://dl.armbian.com/helios4/archive/Armbian_5.59_Helios4_Ubuntu_bionic_next_4.14.66.7z)|bab20c54f3d9b6d6f5b58e594c6b9a58
**Armbian_Helios4_Debian_Stretch_4.14.20.img.xz**<br>Debian 9 Stretch (Kernel 4.14.20)<br>Build date : 17/02/2018<br>Size : 229 MB|[Download](https://cdn.kobol.io/files/Armbian_Helios4_Debian_Stretch_4.14.20.img.xz)|fc98aac0c0f1617061bd6f5112896838
**Armbian_Helios4_Debian_Stretch_4.14.17.img.xz**<br>Debian 9 Stretch (Kernel 4.14.17)<br>Build date : 05/02/2018<br>Size : 230 MB|[Download](https://cdn.kobol.io/files/Armbian_Helios4_Debian_Stretch_4.14.17.img.xz)|89ab81d74300ef346498066bcc742b0a
**Armbian_Helios4_Debian_Stretch_4.14.12.img.xz**<br>Debian 9 Stretch (Kernel 4.14.12)<br>Build date : 06/01/2018<br>Size : 242 MB|[Download](https://cdn.kobol.io/files/Armbian_Helios4_Debian_Stretch_4.14.12.img.xz)|a97fef50ecb1c14a6013695f3b2a51b6

## Image Archives (Old Images)

!!! info
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
