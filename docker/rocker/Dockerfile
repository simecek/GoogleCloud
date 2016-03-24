## Based on rocker/r-base maintained by Carl Boettiger and Dirk Eddelbuettel
FROM rocker/r-base

MAINTAINER "Petr Simecek" lamparna@gmail.com

# devtools dependencies
RUN apt-get -y build-dep libcurl4-gnutls-dev
RUN apt-get -y install libcurl4-gnutls-dev
RUN apt-get -y install libxml2-dev

## install the required R packages
RUN Rscript -e 'install.packages(pkgs = c("qtl", "abind", "curl"), dependencies = TRUE)'
RUN Rscript -e 'install.packages(pkgs = "devtools", dependencies = TRUE)'
RUN Rscript -e 'install.packages(c("yaml", "jsonlite", "data.table", "RcppEigen"), dependencies = TRUE)'
RUN Rscript -e 'devtools::install_github(repo = c("rqtl/qtl2geno", "rqtl/qtl2scan", "rqtl/qtl2plot", "rqtl/qtl2convert"))'
RUN Rscript -e 'devtools::install_github("simecek/intermediate")'
RUN Rscript -e 'devtools::install_github("kbroman/lmmlite")'

