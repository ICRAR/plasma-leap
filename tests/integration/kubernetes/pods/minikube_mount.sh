eval $(minikube docker-env)
# mounts additionally require --driver=docker, --mount and --mount-string args
minikube mount /home/callan/Code/icrar/plasma-leap/tests/integration/msdata/:/msdata/
