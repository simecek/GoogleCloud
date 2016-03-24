## Based on rocker/r-base maintained by Carl Boettiger and Dirk Eddelbuettel
FROM rocker/r-base

MAINTAINER "Petr Simecek" lamparna@gmail.com

## install the required R packages
RUN Rscript -e 'install.packages(pkgs = c("qtl", "abind", "devtools"), dependencies = TRUE)'
RUN Rscript -e 'install.packages(c("yaml", "jsonlite", "data.table", "RcppEigen"), dependencies = TRUE)'
RUN Rscript -e 'devtools::install_github(repo = c("rqtl/qtl2geno", "rqtl/qtl2scan", "rqtl/qtl2plot", "rqtl/qtl2convert"))'
RUN Rscript -e 'devtools::install_github("simecek/intermediate")'
RUN Rscript -e 'devtools::install_github("kbroman/lmmlite")'

