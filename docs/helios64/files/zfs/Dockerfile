FROM ubuntu:bionic
RUN apt update; apt install build-essential autoconf automake bison flex libtool gawk alien fakeroot dkms libblkid-dev uuid-dev libudev-dev libssl-dev zlib1g-dev libaio-dev libattr1-dev libelf-dev python3 python3-dev python3-setuptools python3-cffi libffi-dev -y; apt install software-properties-common -y; add-apt-repository ppa:ubuntu-toolchain-r/test; apt install gcc-10 g++-10 -y; update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10; update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10

