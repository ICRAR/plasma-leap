 
FROM ska-sdp-receive-leap

RUN git clone https://github.com/ICRAR/plasma-leap.git &&\
    cd plasma-leap/tests/integration/msdata/ska &&\
    bash ./install.sh

RUN mv /plasma-leap/tests/integration/msdata /msdata
