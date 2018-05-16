# Build the local source. Not yet optimized but
# leaves development tools in place.
FROM r-base

# Manually copy the files relevant for the build.
# This speeds up the build process while the docker
# file itself is being developed, but eventually
# `COPY . /src/` may be preferred.
COPY R /src/R/
COPY NAMESPACE /src/
COPY DESCRIPTION /src/
COPY man /src/man/
COPY pom.xml /src/
COPY tests /src/tests/
COPY install.R /src/
COPY .Rbuildignore /src/

# Dependencies necessary for install.R
RUN echo "deb-src http://deb.debian.org/debian testing main" >> /etc/apt/sources.list
RUN apt-get update && \
    apt-get -y install libssl-dev libxml2-dev libcurl4-openssl-dev

## Install Java 
RUN apt-get -y install openjdk-8-jdk

## make sure Java can be found in rApache and other daemons not looking in R ldpaths
RUN echo "/usr/lib/jvm/openjdk-8-jdk/jre/lib/amd64/server/" > /etc/ld.so.conf.d/rJava.conf
RUN /sbin/ldconfig

## Install rJava package
RUN apt-get update \
    && apt-get install -y r-base-core r-cran-rjava


RUN useradd -ms /bin/bash t && chown -R t /src/
RUN chown t /usr/local/lib/R/site-library
USER t
WORKDIR /src

RUN Rscript install.R --local
CMD ["/src/tests/runtest"]
