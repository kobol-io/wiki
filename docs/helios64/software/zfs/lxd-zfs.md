When you already have a working ZFS pool (see [here](/helios64/software/zfs/install-zfs/)) and want to use LXD - it is good idea to configure them together.

## **Step 1** - Prepare filesystem

```bash
sudo zfs create -o mountpoint=none mypool/lxd-pool
```

##  **Step 2** - Install LXD

```bash
sudo apt install lxd
```

You might want this:
```bash
sudo usermod -aG lxd <your-username>
```

##  **Step 3** - Configure LXD

```bash
sudo lxc init
```

Configure ZFS this way:
```bash
Do you want to configure a new storage pool (yes/no) [default=yes]?  yes
Name of the new storage pool [default=default]:
Name of the storage backend to use (dir, btrfs, ceph, lvm, zfs) [default=zfs]: zfs
Create a new ZFS pool (yes/no) [default=yes]? no
Name of the existing ZFS pool or dataset: mypool/lxd-pool
[...]
```

##  **Step 4** - Optional

If you use zfs-auto-snapshot, you might want to consider this:

```bash
sudo zfs set com.sun:auto-snapshot=false mypool/lxd-pool
sudo zfs set com.sun:auto-snapshot=true mypool/lxd-pool/containers
sudo zfs set com.sun:auto-snapshot=true mypool/lxd-pool/custom
sudo zfs set com.sun:auto-snapshot=true mypool/lxd-pool/virtual-machines
```

------------

*Page contributed by [michabbs](https://github.com/michabbs)*

*Reference [Armbian Forum Dicussion](https://forum.armbian.com/topic/16559-tutorial-first-steps-with-helios64-zfs-install-config/)*
