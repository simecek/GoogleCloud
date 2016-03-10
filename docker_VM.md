# Virtual Machine And Docker 

This document describes how to create an instrance at Google Cloud and run a docker container on it. Make sure that ports you want to use are not blocked by the firewall rules. 

First log into the instance (I am using Ubuntu 14.04 LTS) and run

```
sudo apt-get update
sudo apt-get install -y docker.io
```

You might want to mount the external disk that is attached to the instance. For example, `datadisk` volume can be mounted to ```/datadisk``` as follows:

```
# to format the disk: sudo mkfs.ext4 -F /dev/disk/by-id/google-datadisk
# create /datadisk folder: sudo mkdir /datadisk
sudo mount -o discard,defaults /dev/disk/by-id/google-datadisk /datadisk
# if you want to add the disk permanently (so you can reboot), sudo nano -w /etc/fstab and add the new line
# /dev/sdb                /datadisk ext4  ro,discard      0 0
```

After that you can pull the docker image and run the docker container. I am giving here two examples: RStudio Server and R/Shiny server. If you are new to Docker, see [the documentation](https://docs.docker.com/).

```
# R/Shiny server
# check that /shiny folder exists
sudo docker run -d -p 3838:3838 -v /shiny/:/srv/shiny-server -v /srv/shinylog:/var/log -v /datadisk:/datadisk --restart=always simecek/shiny

# RStudio Server
# check that /data folder exists
sudo docker run -d -v /datadisk:/datadisk -v /data:/data -p 8787:8787 --restart=always -e USER=rstudio -e PASSWORD=rstudio simecek/rstudio
```

You can list the docker containers as follows

```
sudo docker ps -a
```

Stop and remove the container with `$CONTAINERID`:

```
sudo docker stop $CONTAINERID; sudo docker rm $CONTAINERID 
```

And even log into the running container:

```
sudo docker exec -i -t $CONTAINERID /bin/bash
```

If you run the container with the option `--restart=always` or `--restart=unless-stopped` it will be restarted after reboot.
