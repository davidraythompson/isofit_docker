# ----------------------------------------------------------------------
# Debian baseOS docker container to use with CTSM builds
# ----------------------------------------------------------------------

FROM gcc:6.5
MAINTAINER S.P. Serbin email: sserbin@bnl.gov

RUN useradd -ms /bin/bash clmuser

# Set a few variables that can be used to control the docker build
ARG LIBRADTRAN=2.0.2

# echo back options
RUN echo $HDF5_VERSION
RUN echo $NETCDF_VERSION

ENV PATH=/usr/local/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH
ENV PATH=/usr/local/hdf5/bin:$PATH
ENV PATH=/usr/local/netcdf/bin:$PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/hdf5/lib
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/netcdf/lib

# Update the system and install initial dependencies
RUN apt-get update -y \
    && apt-get install -y \
    cmake \
    git \
    subversion \
    bzip2 \
    libgmp3-dev \
    m4 \
    wget \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    libxml2 \
    libxml2-dev \
    csh \
    liblapack-dev \
    libblas-dev \
    liblapack-dev \
    libffi6 \
    libffi-dev \
    libxml-libxml-perl \
    libxml2-utils \
    vim \
    libudunits2-0 \
    libudunits2-dev \
    udunits-bin \
    htop \
    python2.7 \
    python-dev \
    python-pip \
    python3 \
    python3-pip \
    apt-utils \
    ftp \
    apt-transport-https \
    locales \
    libjson0 \
    libjson0-dev \
    libjson-perl \
    netcdf-bin \
    libnetcdf-dev \
    libhdf5-serial-dev \
    autopoint \
    gsl-bin \
    libgsl0-dev

    ## Install program to configure locales
RUN dpkg-reconfigure locales && \
  locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
      locale-gen
   ## Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

   ## check locales
RUN locale -a

## Compile Expat XML parser
RUN echo "*** Compiling Expat XML parser"
RUN cd / \
    && wget https://github.com/libexpat/libexpat/releases/download/R_2_2_6/expat-2.2.6.tar.bz2 \
    && tar -xvjf expat-2.2.6.tar.bz2 \
    && cd expat-2.2.6 \
    && ./configure \
    && make \
    && make install \
    && cd / \
    && rm -r expat-2.2.6 \
    && rm expat-2.2.6.tar.bz2

   ## build FLEX
RUN echo "*** Compiling FLEX "
RUN cd / \
    && wget https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz \
    && tar -zxvf flex-2.6.4.tar.gz \
    && cd flex-2.6.4 \
    && ./autogen.sh \
    && ./configure && make && make install

   ## build libradtran
RUN echo "*** Compiling libradtran " ${LIBRADTRAN}
RUN cd / \
    && wget http://www.libradtran.org/download/libRadtran-${LIBRADTRAN}.tar.gz \
    && tar -zxvf libRadtran-${LIBRADTRAN}.tar.gz \
    && cd libRadtran-${LIBRADTRAN} \
    && ./configure \
    && make

RUN cd / \
    && python3 -m pip install numpy \
    && python3 -m pip install scipy \
    && python3 -m pip install numba

### EOF
