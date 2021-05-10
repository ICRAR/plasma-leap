#!/bin/bash
# See https://gitlab.com/ska-telescope/cbf-sdp-emulator/-/blob/master/quickstart/plasma/run.sh

# Dependencies:
# install https://gitlab.com/ska-telescope/cbf-sdp-emulator
# install https://gitlab.com/ska-telescope/ska-ser-logging
# install https://gitlab.com/ska-telescope/sdp/ska-sdp-dal
# install https://gitlab.com/ska-telescope/sdp/ska-sdp-dal-schemas
# install https://gitlab.com/ska-telescope/plasma-storage-manager
# install https://gitlab.com/ska-telescope/icrar-leap-accelerate

# Pipeline:
# CBF-SDP-SENDER
CBF_SDP_SENDER_COMMAND=emu-send
CBF_SDP_SENDER_ARGS="-c ./functest.conf ./functest.ms"

# CBF-SDP-RECEIVER
CBF_SDP_RECEIVER_COMMAND=emu-recv
CBF_SDP_RECEIVER_ARGS="-c ./functest.conf"

# PLASMA-MSWRITER
PLASMA_MSWRITER_COMMAND=plasma-mswriter
PLASMA_MSWRITER_ARGS="./functest-plasma.ms --max_payloads 1 --use_plasma_ms true -c 'LeapAccelerateCLI -c leap-ngas.json -f %s'"

# PLASMA-STORE
PLASMA_STORE_COMMAND=plasma_store
PLASMA_STORE_ARGS="-s /tmp/plasma -m 2000000000"

session=ngas

finally() {
    echo
    echo "killing process.."
    # tmux kill-session -t $session
    kill -TERM -$$
}

plasma_store_function() {
    echo "starting plasma store"
    $PLASMA_STORE_COMMAND $PLASMA_STORE_ARGS | sed -e 's/^/[PLASMA-STORE] /'
}

plasma_consumers() {
    #while true; do
    echo "starting plasma mswriter"
    eval $PLASMA_MSWRITER_COMMAND "$PLASMA_MSWRITER_ARGS" | sed -e 's/^/[PLASMA-MSWRITER] /'
    PLASMA_MSWRITER_PID=$!
}

cbf_receiver() {
    echo "starting cbf-sdp receiver"
    $CBF_SDP_RECEIVER_COMMAND $CBF_SDP_RECEIVER_ARGS | sed -e 's/^/[CBF-SDP-RECEIVER] /'
}

cbf_sender() {
    echo "starting cbf-sdp sender"
    $CBF_SDP_SENDER_COMMAND $CBF_SDP_SENDER_ARGS | sed -e 's/^/[CBF-SDP-SENDER] /'
}

run_tmux() {
    trap finally INT
    tmux new -s $session -d
    tmux send-keys -t $session "bash ngas.sh plasma_store_function" Enter
    tmux split-window -h
    sleep 2
    tmux send-keys -t $session "bash ngas.sh plasma_consumers" Enter
    tmux select-pane -t 0
    tmux split-window -v
    sleep 1
    tmux send-keys -t $session "bash ngas.sh cbf_receiver" Enter
    tmux split-window -v
    sleep 1
    tmux send-keys -t $session "bash ngas.sh cbf_sender" Enter
    tmux attach-session -t $session
}

run() {
    trap finally INT
    plasma_store_function &
    sleep 2
    plasma_consumers &
    sleep 2
    cbf_receiver &
    sleep 2
    cbf_sender &
    sleep 2
    wait
}

# Run first argument
"$@"
