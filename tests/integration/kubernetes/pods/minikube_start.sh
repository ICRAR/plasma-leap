# allow minikube to access host docker images
eval $(minikube docker-env)
minikube start --driver=docker --mount=true --mount-string /home/callan/Code/icrar/msdata/:/mnt/msdata/
eval $(minikube docker-env)
# new minikube containers requires cached docker images to be rebuilt..
# docker build -t plasma-leap-receiver ../../../../sdp-dal-receive-leap
# mounts additionally require --driver=docker, --mount and --mount-string args
minikube mount /home/callan/Code/icrar/msdata/:/msdata/
