## Based on rocker/hadleyverse maintained by Carl Boettiger and Dirk Eddelbuettel
FROM rocker/shiny

MAINTAINER "Petr Simecek" lamparna@gmail.com

RUN apt-get -y update && apt-get -y install libxml2-dev 
RUN apt-get -y install libssl-dev

RUN Rscript -e 'install.packages(pkgs = "devtools", dependencies = TRUE)'
RUN Rscript -e 'install.packages(pkgs = "qtl", dependencies = TRUE)'
RUN Rscript -e 'install.packages(pkgs = "qtlcharts", dependencies = TRUE)'
RUN Rscript -e 'install.packages(pkgs = "ggplot2", dependencies = TRUE)'
RUN Rscript -e 'install.packages(c("yaml", "jsonlite", "data.table", "RcppEigen"), dependencies = TRUE)'
RUN Rscript -e 'devtools::install_github(repo = c("rqtl/qtl2geno", "rqtl/qtl2scan"))'
RUN Rscript -e 'devtools::install_github("simecek/intermediate")'
