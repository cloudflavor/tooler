Nspawn-toolbox
---
Bootstrap running debugging containers with systemd-nspawn.  

#### Using it remote, Dockerless


Unfortunately, ` machinectl pull-dkr` was
[deprecated](https://github.com/systemd/systemd/commit/b43d75c378d919900e5c1e82a82e3e17dd3de9f9)
because the systemd implementation couldn't keep up with the
forever-breaking-api of docker, so pulling docker images  directly from a docker
registry is no longer possible (or might be possible but wouldn't work
properly).

The way this works is to pull the tar.gz
[release](https://github.com/codeflavor/nspawn-toolbox/releases).

```
$ machinectl pull-tar https://github.com/codeflavor/nspawn-toolbox/releases/download/v0.0.1/opensuse.tar.gz
Download of https://github.com/codeflavor/nspawn-toolbox/releases/download/v0.0.1/opensuse.tar.gz complete.
Created new local image 'opensuse'.
Created new settings file 'opensuse.nspawn'
Operation completed successfully.
Exiting.

codeflavor:nspawn-toolbox$ machinectl list-images
NAME     TYPE      RO  USAGE  CREATED                     MODIFIED
opensuse subvolume no  224.8M Sun 2017-02-26 01:03:29 CET n/a     

1 images listed.
```
Start and list your container:
```
codeflavor:nspawn-bootstrap$ machinectl start opensuse

codeflavor:nspawn-bootstrap$ machinectl list
MACHINE  CLASS     SERVICE       
opensuse container systemd-nspawn

1 machines listed.
```
See the status:
```
codeflavor:nspawn-bootstrap$ machinectl status opensuse
opensuse
           Since: Sun 2017-02-26 01:31:27 CET; 1min 8s ago
          Leader: 4210 (systemd)
         Service: systemd-nspawn; class container
            Root: /var/lib/machines/opensuse
           Iface: ve-opensuse
              OS: openSUSE Leap 42.2
            Unit: systemd-nspawn@opensuse.service
                  ├─4207 /usr/bin/systemd-nspawn --quiet --keep-unit --boot --link-journal=try-guest --network-veth --settings=override --machine=opensuse
                  ├─init.scope
                  │ └─4210 /usr/lib/systemd/systemd
                  └─system.slice
                    ├─systemd-journald.service
                    │ └─4230 /usr/lib/systemd/systemd-journald
                    └─console-getty.service
                      └─4261 /sbin/agetty --noclear --keep-baud console 115200 38400 9600 vt220
```



#### Using locally (requires Docker)
By default the main [Dockerfile](Dockerfile) contains [all the linux utilities](TOOLBOX.md) that you need
for debugging. But you can also edit it to your liking.

`sudo make build` - This will build the `Dockerfile` creating a systemd-nspawn
compatible root file system that you can then use to spawn a new container.  

`sudo systemd-nspawn -D rootfs/`


Installing additional tools in your container without rebuilding the image.
```
codeflavor:nspawn-toolbox$ sudo systemd-nspawn -D rootfs/
Spawning container rootfs on /home/codeflavor/projects/nspawn-toolbox/rootfs.
Press ^] three times within 1s to kill container.
Timezone Europe/Prague does not exist in container, not updating container timezone.
-bash-4.3# nload
-bash: nload: command not found
rootfs:~ # logout
Container rootfs exited successfully.
```
Post install a specific tool before, or in between, runs.
```
codeflavor:nspawn-toolbox$ sudo zypper --root=/home/codeflavor/projects/nspawn-toolbox/rootfs/ in nload
```

Watch it work!

```
codeflavor:nspawn-toolbox$ sudo systemd-nspawn -D rootfs/
Spawning container rootfs on /home/codeflavor/projects/nspawn-toolbox/rootfs.
Press ^] three times within 1s to kill container.
Timezone Europe/Prague does not exist in container, not updating container timezone.
rootfs:~ # which nload
/usr/bin/nload
```

Controlling your container is easy as well with `machinectl`.

```
codeflavor:~$ machinectl list
MACHINE CLASS     SERVICE       
rootfs  container systemd-nspawn

1 machines listed.
codeflavor:~$
```

Perform a wider range of operations with a more privilleged container.
_see `man capabilities` for more._
```
sudo systemd-nspawn -D rootfs/ --capability CAP_SYS_ADMIN
```


Reference:  
https://seanmcgary.com/posts/nsenter-a-systemd-nspawn-container  
https://github.com/gabx/thetradinghall/wiki/Systemd-nspawn-container  
