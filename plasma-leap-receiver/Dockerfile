# This is Dockerfile installs everything from scratch into a Ubuntu 20.04 based container
FROM ubuntu:20.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata \
    gnupg2 software-properties-common wget git git-lfs gcc g++ make tmux python3-pip cmake libboost1.71-all-dev

# install casacore
RUN mkdir -p /code && cd /code &&\
    add-apt-repository -s ppa:kernsuite/kern-7 &&\
    apt-add-repository multiverse &&\
    apt-add-repository restricted &&\
    apt update &&\
    apt install -y casacore-dev

# install arrow-plasma
# RUN apt update && apt install -y wget &&\
#     mkdir -p /code && cd /code &&\
#     wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb &&\
#     apt install -y -V ./apache-arrow-archive-keyring-latest-$(lsb_release --codename --short).deb &&\
#     sed -i'' -e 's,https://apache.bintray.com/,https://apache.jfrog.io/artifactory/,g' /etc/apt/sources.list.d/apache-arrow.sources &&\
#     apt update &&\
#     apt install -y libarrow-dev libplasma-dev

# build and install arrow-plasma
# NOTE: nvidia-docker requires using newer cuda packages than ones included with arrow-plasma that do not overwrite the the docker cuda drivers
RUN mkdir -p /code && cd /code &&\
    git clone --recursive -b apache-arrow-4.0.0 https://github.com/apache/arrow.git &&\
    cd arrow/cpp &&\
    cmake -B build . -DCMAKE_BUILD_TYPE=Release -DARROW_PLASMA=ON -DARROW_TESTING=OFF &&\
    cmake --build build/ --target all -j2 &&\
    cmake --build build/ --target install &&\
    ldconfig &&\
    cd ../..

# build and install plasmastman
RUN mkdir -p /code && cd /code &&\
    git clone --recursive https://gitlab.com/ska-telescope/plasma-storage-manager.git &&\
    cd plasma-storage-manager &&\
    cmake -B build . -DCMAKE_BUILD_TYPE=Release -DPlasma_DIR=/usr/local/lib/cmake/arrow -DArrow_DIR=/usr/local/lib/cmake/arrow -DBUILD_TESTING=OFF &&\
    cmake --build build/ --target all -j2 &&\
    cmake --build build/ --target install &&\
    ldconfig &&\
    cd ..

# install pyarrow
RUN pip3 install pyarrow==3.0.0

# build and install cbf-sdp-emulator
RUN mkdir -p /code && cd /code &&\
    git clone -b yan-657/write_plasma_ms --recursive https://gitlab.com/ska-telescope/cbf-sdp-emulator.git &&\
    cd cbf-sdp-emulator &&\
    pip3 install --extra-index-url=https://nexus.engageska-portugal.pt/repository/pypi/simple -e .[plasma] &&\
    cd data/; tar xf sim-vis.ms.tar.gz; cd ..

# install cuda
# RUN mkdir -p /code && cd /code &&\
#     wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin &&\
#     mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 &&\
#     apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub &&\
#     add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" &&\
#     apt update

# RUN DEBIAN_FRONTEND=noninteractive apt -y --no-install-recommends install \
#     cuda-minimal-build-11-2 cuda-libraries-11-2 cuda-libraries-dev-11-2

# # build and install leap-accelerate
# RUN mkdir -p /code && cd /code &&\
#     git clone -b yan-588/test-calibrations --recursive https://gitlab.com/ska-telescope/icrar-leap-accelerate.git &&\
#     cd icrar-leap-accelerate &&\
#     export CUDA_HOME=/usr/local/cuda-11.2 &&\
#     export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${CUDA_HOME}/lib64:${CUDA_HOME}/extras/CUPTI/lib64 &&\
#     export PATH=$PATH:$CUDA_HOME/bin &&\
#     mkdir -p build/linux/Release && cd build/linux/Release &&\
#     cmake ../../.. -DCMAKE_BUILD_TYPE=Release -DCUDA_ENABLED=ON -DBUILD_TESTING=OFF &&\
#     make install

# # # setup pipeline files
# RUN mkdir -p /code && cd /code &&\
#     git clone --recursive https://gitlab.com/calgray/plasma-leap.git

# Second stage to cleanup the mess
# FROM ubuntu:20.04
# COPY --from=0 /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu
# COPY --from=0 /usr/local /usr/local
# RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends liblapack3

# # add a user to run this container under rather than root.
# RUN useradd ray
# USER ray
# WORKDIR /home/ray
# CMD ["/usr/local/bin/LeapAccelerateCLI", "--help"]
