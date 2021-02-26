#!/bin/bash

#define zfs version
zfsver="zfs-2.0.3"
#creating building directory
mkdir /tmp/zfs-builds && cd "$_"
rm -rf /tmp/zfs-builds/build-zfs.sh
apt-get download linux-headers-current-rockchip64
git clone -b $zfsver https://github.com/openzfs/zfs.git $zfsver-$(uname -r)

#create file to execute inside container
echo "creating ZFS build script to be executed inside container"
cat > /tmp/zfs-builds/build-zfs.sh  <<EOF
#!/bin/bash
cd scratch/
dpkg -i linux-headers-current-*.deb

cd "/scratch/$zfsver-$(uname -r)"
sh autogen.sh
./configure
make -s -j$(nproc)
make deb
mkdir "/scratch/deb-$zfsver-$(uname -r)"
cp *.deb "/scratch/deb-$zfsver-$(uname -r)"
rm -rf  "/scratch/$zfsver-$(uname -r)"
exit
EOF

chmod +x /tmp/zfs-builds/build-zfs.sh

echo ""
echo "####################"
echo "starting container.."
echo "####################"
echo ""
docker run --rm -it -v /tmp/zfs-builds:/scratch zfs-build-ubuntu-bionic:0.1 /bin/bash /scratch/build-zfs.sh

# Cleanup packages (if installed).
modprobe -r zfs zunicode zzstd zlua zcommon znvpair zavl icp spl
apt remove --yes zfsutils-linux zfs-zed zfs-initramfs
apt autoremove --yes
dpkg -i "/tmp/zfs-builds/deb-$zfsver-$(uname -r)"/kmod-zfs-$(uname -r)*.deb
dpkg -i "/tmp/zfs-builds/deb-$zfsver-$(uname -r)"/{libnvpair3,libuutil3,libzfs4,libzpool4,python3-pyzfs,zfs}_*.deb

echo ""
echo "###################"
echo "building complete"
echo "###################"
echo ""
