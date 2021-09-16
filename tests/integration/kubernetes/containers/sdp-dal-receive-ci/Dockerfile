 
FROM ska-sdp-receive-leap

RUN git clone -b k8s-tests https://github.com/ICRAR/plasma-leap.git &&\
    cd plasma-leap/tests/integration/msdata/mwa &&\
    bash ./install.sh

RUN mv /plasma-leap/tests/integration/msdata /msdata
