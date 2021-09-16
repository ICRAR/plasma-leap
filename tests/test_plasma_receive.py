#!usr/bin/env python

import pytest
from kubernetes import client, config

@pytest.fixture
def k8s_client() -> client.CoreV1Api:
    config.load_kube_config("~/.kube/config")
    return client.CoreV1Api()

def test_kubernetes_components_healthy(k8s_client):
    components = k8s_client.list_component_status()
    for component in components.items:
        assert component.conditions[0].type == "Healthy"

def test_kubernetes_master_controller_status_is_healthy(k8s_client):
    ret = k8s_client.read_component_status('controller-manager')
    assert(ret.conditions[0].type == "Healthy" ) # Verify status of Master Controller

def test_kubernetes_node_status(k8s_client):
    nodes = k8s_client.list_node()

    for item in nodes.items:
        assert item.metadata.name == "minikube"
        node = k8s_client.read_node_status(name=item.metadata.name)
        assert node.status.conditions[0].status == "False"
        assert node.status.conditions[1].status == "False"
        assert node.status.conditions[2].status == "False"
        assert node.status.conditions[3].type == "Ready"

def test_kubernetes_pod_status_is_completed(k8s_client):
    podlist = k8s_client.list_namespaced_pod("default")
    # Iterate through all the pods in the default namespace and verify that they are Running
    for item in podlist.items:
        pod = k8s_client.read_namespaced_pod_status(namespace='default', name=item.metadata.name)
        print("%s\t%s\t" % (item.metadata.name, item.metadata.namespace))
        print(pod.status.phase)
        assert(pod.status.phase == "Completed")