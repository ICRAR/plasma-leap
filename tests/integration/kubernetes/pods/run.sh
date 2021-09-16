#minikube stop
#eval $(minikube -p minikube docker-env)
#systemctl restart docker
#minikube start
kubectl apply -f ./plasma-receive-workflow-pod.yaml
