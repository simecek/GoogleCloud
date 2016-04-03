FROM ubuntu:14.04

MAINTAINER "Petr Simecek" lamparna@gmail.com

# devtools external dependencies
RUN apt-get -y update && apt-get -y upgrade && \
    apt-get install -y python-numpy && \
    apt-get install -y python-scipy
    
ADD gbrs /bin/
ADD interpolate2 /bin/
