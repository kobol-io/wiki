When you already have a working ZFS pool (see [here](/helios64/software/zfs/install-zfs/)) and want to use Docker - it is good idea to configure them together.

## **Step 1** - Prepare filesystem

```bash
sudo zfs create -o mountpoint=/var/lib/docker mypool/docker-root
sudo zfs create -o mountpoint=/var/lib/docker/volumes mypool/docker-volumes
sudo chmod 700 /var/lib/docker/volumes
```

Optional: If you use zfs-auto-snapshot, you might want to consider this:

```bash
sudo zfs set com.sun:auto-snapshot=false mypool/docker-root
sudo zfs set com.sun:auto-snapshot=true mypool/docker-volumes
```

Create `/etc/docker/daemon.json` with the following content:

```bash
{
  "storage-driver": "zfs"
}
```

##  **Step 2** - Install Docker

!!! Note
    You can easily install docker by using **armbian-config** tool.

    *armbian-config -> software -> softy -> docker*

Add `/etc/apt/sources.list.d/docker.list` with the following content:

```bash
deb [arch=arm64] https://download.docker.com/linux/ubuntu focal stable
# deb-src [arch=arm64] https://download.docker.com/linux/ubuntu focal stable
```

Proceed with installation:

```bash
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
```

You might want this:
```bash
sudo usermod -aG docker <your-username>
```

Voila! Your Docker should be ready! Test it:

```bash
docker run hello-world
```

##  **Step 3** - Optional: Install Portainer

```bash
sudo zfs create mypool/docker-volumes/portainer_data
# You might omit the above line if you do not want to have separate dataset for the docker volume (bad idea).

docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
```

Go to `http://yourip:9000` and configure.

------------

*Page contributed by [michabbs](https://github.com/michabbs)*

*Reference [Armbian Forum Dicussion](https://forum.armbian.com/topic/16559-tutorial-first-steps-with-helios64-zfs-install-config/)*
