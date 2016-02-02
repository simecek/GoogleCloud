# R/Shiny Docker Container

We currently use (rocker/shiny)[https://hub.docker.com/r/rocker/shiny/] docker image that will be later customized for our needs.

The script below is installing all required R packages that `kidney` app uses:

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