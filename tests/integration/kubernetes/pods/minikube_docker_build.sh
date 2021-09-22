eval $(minikube docker-env)
# new minikube containers requires cached docker images to be rebuilt..
docker build -t ska-sdp-receive-leap ../../../../ska-sdp-receive-leap
