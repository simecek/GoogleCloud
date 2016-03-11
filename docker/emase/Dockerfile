FROM debian:jessie
MAINTAINER Petr Simecek <petrs@jax.org>
# adapted from KB's asesuite image

# System packages 
RUN apt-get update && apt-get install -y \
    gcc-4.9 \
    g++-4.9 \
    git \
    wget \
    python \
    python-dev \
    python-pip \
    libhdf5-serial-dev \
    sqlite3 \
    libsqlite3-dev \
    python-numexpr \
    python-numpy \
    python-matplotlib \
    python-tables \
#    python-scipy \
    gfortran \
    libblas-dev \
    libatlas-dev \
    liblapack-dev \
    ipython \
    libffi-dev \
    libssl-dev 

# Python packages
RUN pip install biopython==1.63
RUN pip install pysam
RUN pip install bx-python
RUN pip install pytabix
RUN pip install pysqlite
RUN pip install scipy==0.13.3
RUN pip install cython
RUN pip install progressbar


