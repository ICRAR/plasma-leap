# allow minikube to access host docker images
eval $(minikube docker-env)
minikube start --driver=docker --mount=true --mount-string /home/callan/Code/icrar/msdata/:/mnt/msdata/
eval $(minikube docker-env)
# new minikube containers requires cached docker images to be rebuilt..
## docker build -t plasma-leap-receiver ../../../../sdp-dal-receive-leap
docker build -t ska-sdp-receive-leap ../../../../ska-sdp-receive-leap

# alternative to mounting, include scripts to download msdata
docker build -t ska-sdp-receive-leap-ci ../containers/ska-sdp-receive-leap-ci

# mounts additionally require --driver=docker, --mount and --mount-string args
#minikube mount /home/callan/Code/icrar/msdata/:/msdata/
