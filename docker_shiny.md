# R/Shiny Docker Container

We currently use (rocker/shiny)[https://hub.docker.com/r/rocker/shiny/] docker image that will be later customized to our needs.

The script below installs all required R packages that `kidney` app uses:

```
sudo apt-get update
sudo apt-get install libxml2-dev
sudo apt-get install libssl-dev

sudo Rscript -e 'install.packages(pkgs = "devtools", dependencies = TRUE)'
sudo Rscript -e 'install.packages(pkgs = "qtl", dependencies = TRUE)'
sudo Rscript -e 'install.packages(pkgs = "qtlcharts", dependencies = TRUE)'
sudo Rscript -e 'install.packages(pkgs = "ggplot2", dependencies = TRUE)'
sudo Rscript -e 'devtools::install_github("simecek/intermediate")'
```

You need to run the script inside the docker container. You can log into the running docker container as follows:

```
sudo docker exec -i -t $CONTAINERID /bin/bash
```