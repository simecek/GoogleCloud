# RStudio Server Docker Container

We currently use [rocker/hadleyverse](https://hub.docker.com/r/rocker/hadleyverse/) docker image that will be later customized to our needs.

The script below installs several R packages useful for qtl mapping:

```
sudo Rscript -e 'install.packages(pkgs = "qtl", dependencies = TRUE)'
sudo Rscript -e 'source("http://bioconductor.org/biocLite.R"); biocLite(c("DOQTL"), ask=FALSE)'
sudo Rscript -e 'devtools::install_github(repo = "dmgatti/DOQTL")'
sudo Rscript -e 'install.packages(c("yaml", "jsonlite", "data.table", "RcppEigen"), dependencies = TRUE)'
sudo Rscript -e 'devtools::install_github(repo = c("rqtl/qtl2geno", "rqtl/qtl2scan"))'
sudo Rscript -e 'devtools::install_github("simecek/intermediate")'
```

Moreover, the second script adds users to RStudio Server:
```
for USER in "petr" "gary" "ben" "xu" "david" "gail" "johan"
do
  echo "Adding the user $USER"
  useradd $USER && echo "$USER:rstudio" | chpasswd
  mkdir /home/$USER && chown $USER:$USER /home/$USER
  addgroup $USER rstudio
  ln -s /datadisk "/home/$USER/datadisk" && ln -s /data "/home/$USER/shared"
done
```

You need to run the scripts inside the docker container. You can log into the running docker container as follows:

```
sudo docker exec -i -t $CONTAINERID /bin/bash
```