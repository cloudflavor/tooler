bootstrap running containers with systemd-nspawn with the help of Docker.  

`sudo make build` - This will build the `Dockerfile` creating a systemd-nspawn
compatible root file system that you can then use to spawn a new container.  

`sudo systemd-nspawn -D rootfs/`


Installing additional tools in your container without rebuilding the image.
```
codeflavor:nspawn-bootstrap$ sudo systemd-nspawn -D rootfs/
Spawning container rootfs on /home/codeflavor/projects/nspawn-bootstrap/rootfs.
Press ^] three times within 1s to kill container.
Timezone Europe/Prague does not exist in container, not updating container timezone.
-bash-4.3# nload
-bash: nload: command not found
rootfs:~ # logout
Container rootfs exited successfully.
```
```
codeflavor:nspawn-bootstrap$ sudo zypper --root=/home/codeflavor/projects/nspawn-bootstrap/rootfs/ in nload
```

```
codeflavor:nspawn-bootstrap$ sudo systemd-nspawn -D rootfs/
Spawning container rootfs on /home/codeflavor/projects/nspawn-bootstrap/rootfs.
Press ^] three times within 1s to kill container.
Timezone Europe/Prague does not exist in container, not updating container timezone.
rootfs:~ # which nload
/usr/bin/nload
```
