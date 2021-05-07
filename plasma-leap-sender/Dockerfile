# This is Dockerfile installs everything from scratch into a Ubuntu 20.04 based container
FROM ubuntu:20.04
RUN apt update &&\
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends tzdata \
    gnupg2 software-properties-common wget gcc g++ git git-lfs python3-pip

# install cbf-sdp-emulator
# ARG PYPI_REPOSITORY_URL=https://nexus.engageska-portugal.pt/repository/pypi
# RUN apt install -y python3-casacore
# RUN pip3 install pyarrow==3.0.0
# RUN git clone --recursive https://gitlab.com/ska-telescope/cbf-sdp-emulator.git &&\
#     cd cbf-sdp-emulator &&\
#     pip3 install --extra-index-url=$PYPI_REPOSITORY_URL/simple -e . &&\
#     cd data/; tar xf sim-vis.ms.tar.gz; cd ..

#CMD ["/run.sh"]

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
