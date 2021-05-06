# This is Dockerfile installs everything from scratch into a Ubuntu 20.04 based container
FROM ubuntu:20.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata \
    gnupg2 software-properties-common wget git gcc g++ gdb cmake casacore-dev libboost1.71-all-dev

# install casacore
RUN add-apt-repository -s ppa:kernsuite/kern-7 &&\
    apt-add-repository multiverse &&\
    apt-add-repository restricted &&\
    apt update &&\
    apt install -y casacore-dev

#install arrow-plasma
RUN apt update && apt install -y wget &&\
    wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb &&\
    apt install -y -V ./apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb &&\
    sed -i'' -e 's,https://apache.bintray.com/,https://apache.jfrog.io/artifactory/,g' /etc/apt/sources.list.d/apache-arrow.sources &&\
    apt update &&\
    apt install -y libarrow-dev libplasma-dev

#install cuda
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin &&\
    mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 &&\
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub &&\
    add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"  &&\
    apt update &&\
    DEBIAN_FRONTEND=noninteractive apt -y --no-install-recommends install cuda-11-2


# Get the LEAP sources and install them in the system
RUN git clone --recursive https://gitlab.com/ska-telescope/icrar-leap-accelerate.git &&\
    export CUDA_HOME=/usr/local/cuda &&\
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${CUDA_HOME}/lib64:${CUDA_HOME}/extras/CUPTI/lib64 &&\
    export PATH=$PATH:$CUDA_HOME/bin &&\
    mkdir -p build/linux/Debug && cd build/linux/Debug &&\
    cmake ../../.. -DCMAKE_BUILD_TYPE=Release &&\
    make install

# Second stage to cleanup the mess
# FROM ubuntu:20.04
# COPY --from=0 /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu
# COPY --from=0 /usr/local /usr/local
# RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends liblapack3

# # add a user to run this container under rather than root.
# RUN useradd ray
# USER ray
# WORKDIR /home/ray
CMD ["/usr/local/bin/LeapAccelerateCLI", "--help"]
