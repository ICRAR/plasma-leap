#!usr/bin/env python

from typing import List
from enum import Enum
from dataclasses import dataclass
import pytest
import time
import yaml
from os import path
from kubernetes import client, config, watch
from kubernetes.client.rest import ApiException

#PLASMA_TEST_NAMESPACE = 'plasma-receive-tests'
PLASMA_TEST_NAMESPACE = 'default'
# 'plasma-receive-askap'
TEST_POD_NAME = 'plasma-receive-workflow-pod'

class PodPhase(Enum):
    Pending = "Pending"
    Running = "Running"

@dataclass
class PodState:
    running: int
    waiting: int
    completed: int
    failed: int

    @classmethod
    def from_container_states(cls, container_states: List[client.V1ContainerState]):
        pod_state = PodState(0,0,0,0)
        for state in container_states:
            if state.running != None:
                pod_state.running = pod_state.running + 1
            if state.waiting != None:
                pod_state.waiting = pod_state.waiting + 1
            if state.terminated != None:
                if state.terminated.exit_code == 0:
                    pod_state.completed = pod_state.completed + 1
                else:
                    pod_state.failed = pod_state.failed + 1
        return pod_state

    @classmethod
    def from_container_statuses(cls, container_statuses):
        pod_state = PodState(0,0,0,0)
        for status in container_statuses:
            state = status.state
            if state.running != None:
                pod_state.running = pod_state.running + 1
            if state.waiting != None:
                pod_state.waiting = pod_state.waiting + 1
            if state.terminated != None:
                if state.terminated.exit_code == 0:
                    pod_state.completed = pod_state.completed + 1
                else:
                    pod_state.failed = pod_state.failed + 1
        return pod_state

@pytest.fixture
def k8s_client() -> client.CoreV1Api:
    config.load_kube_config("~/.kube/config")
    return client.CoreV1Api()

def test_plasma_receive_askap(k8s_client):
    resp: client.V1Pod = None

    try:
        resp = k8s_client.read_namespaced_pod(name=TEST_POD_NAME, namespace=PLASMA_TEST_NAMESPACE)
        raise Exception("Test pod aleady running")
    except ApiException as e:
        if e.status != 404:
            raise
    
    with open(path.join(path.dirname(__file__), "integration/kubernetes/pods/plasma-receive-askap-workflow-pod.yaml")) as f:
        pod_manifest = yaml.safe_load(f)

    #k8s_client.create_namespace()
    resp = k8s_client.create_namespaced_pod(body=pod_manifest, namespace=PLASMA_TEST_NAMESPACE)
    
    try:
        last_state = PodState(0,0,0,0)
        w = watch.Watch()
        pod_completed = False
        for event in w.stream(k8s_client.list_namespaced_pod, PLASMA_TEST_NAMESPACE, timeout_seconds=10):
            pod: client.V1Pod = event['object']
            #print(f"Event: {event['type']} {pod.kind} {pod.metadata.name}")
            #print(f"{pod.status} {dir(pod)}")

            if pod.status.phase != PodPhase.Pending.name:
                container_states = []
                for status in pod.status.container_statuses:
                    status: client.V1ContainerStatus
                    container_states.append(status.state)
                print(container_states)

                #last_state = PodState.from_container_states(container_states)
                last_state = PodState.from_container_statuses(pod.status.container_statuses)

                print(last_state)
                if last_state == PodState(2, 0, 2, 0):
                    pod_completed = True
                    break

    finally:
        k8s_client.delete_namespaced_pod(name=TEST_POD_NAME, namespace=PLASMA_TEST_NAMESPACE, grace_period_seconds=0)
        pass

    assert pod_completed