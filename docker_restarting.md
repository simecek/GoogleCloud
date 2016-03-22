# Stop And Restart Docker Container

To save money, it is advised to run VMs only when you actually use them. However, it is a bit tricky to do so with docker containers. There are three issues: after VM rebooting the docker service must be restarted, the docker container itself must be restarted and the disks must be remounted. 

### Docker daemon

There is a difference between Ubuntu 14.10 and Ubuntu 15.04 in boot and service manager. Ubuntu 14.04 (`upstart`) restarts the docker daemon automatically, while for Ubuntu 15.04 onwards (`systemd`) you need to register docker service with

```
sudo systemctl enable docker
```

For the moment I would recommend to use Ubuntu 14.10.

### Docker container restart

If you want your container to be restarted after VM reboots, just use the option  `--restart=always`. For example

```
sudo docker run -d -p 8787:8787 --restart=always -e simecek/rstudio
```

### Mounting the disk

Previously, I mounted disks with `mount` command. However, such a disk disappears when VM reboots. You need to change `/etc/fstab` file to mount the disk permanently. 

For example, to mount `/datadisk` in read-only mode, add the following line:
```
/dev/sdb                /datadisk ext4  ro,discard      0 0
```
