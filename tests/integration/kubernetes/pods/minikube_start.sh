# allow minikube to access host docker images
eval $(minikube docker-env)
minikube start --driver=docker --mount=true --mount-string /home/callan/Code/icrar/msdata/:/mnt/msdata/
#minikube start --driver=docker --mount=true --mount-string $PWD/../../msdata/:/mnt/msdata/
