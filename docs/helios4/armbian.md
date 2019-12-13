# Armbian

Debian & Ubuntu based Linux for ARM based single-board computers

[https://www.armbian.com](https://www.armbian.com "Armbian")

**Note:** The Kobol Team has joined the Armbian team to be the official maintainer of Armbian build for **mvebu** SoC family. This way all efforts are consolidated into a single build platform to provide the best Operating System support for Helios4.

## Pre-built images

You can find pre-built **Armbian** images for Helios4 on our [Download](/helios4/download) page or directly on [Armbian website](https://dl.armbian.com/helios4/).

## How to build an image or a kernel?

Supported build environment is **Ubuntu Bionic 18.04 x64** ([minimal iso image](http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/current/images/netboot/mini.iso)).

- guest inside a [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or other virtualization software,
- guest managed by [Vagrant](https://www.vagrantup.com/). This uses Virtualbox (as above) but does so in an easily repeatable way. Please check the [Armbian with Vagrant README](https://docs.armbian.com/Developer-Guide_Using-Vagrant/) for a quick start HOWTO,
- inside a [Docker](https://www.docker.com/), [systemd-nspawn](https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html) or other container environment [(example)](https://github.com/armbian/build/pull/255#issuecomment-205045273),
- running natively on a dedicated PC or a server (**not** recommended),
- **20GB disk space** or more and **2GB RAM** or more available for the VM, container or native OS,
- superuser rights (configured `sudo` or root access).

**Execution**

	apt-get -y install git
	git clone https://github.com/armbian/build
	cd build
	./compile.sh

Make sure that full path to the build script does not contain spaces.

You will be prompted with a selection menu for a build option, a board name, a kernel branch and an OS release. Please check the documentation for [advanced options](https://docs.armbian.com/Developer-Guide_Build-Options/) and [additional customization](https://docs.armbian.com/Developer-Guide_User-Configurations/).

Build process uses caching for the compilation and the debootstrap process, so consecutive runs with similar settings will be much faster.

*Source: [link](https://github.com/armbian/build/blob/master/README.md)*
