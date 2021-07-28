# Plasma-Leap-Pipeline Docker Image

## Summary

plasma-leap-receiver is a docker image including an entire pipeline for performing gpu-accelerated leap calibration on network recieved spead2 observations using a plasma in-memory data store. Included is a samples folder containing pipeline configurations for different observation sources.

### Pipeline Diagram

![pipeline-diagram](/images/mem-workflow.jpg "Plasma-Leap Pipeline")

### Run docker image on AWS Instance

```
cd ~/leap-pipeline/plasma-leap/samples/ska
docker run -it --rm --gpus=all --shm-size=3000000000 --ipc=shareable \
--mount type=bind,src=$PWD,dst=/code/plasma-leap/samples/ska \
plasma-leap-receiver
```

### Test pipeline in docker container on AWS Instance

```
cd /code/plasma-leap/samples/ska
bash ska.sh run_tmux
```

Upon running it should be observed that LeapAccelerateCLI is called in the right tmux window and outputs a calibration array of numbers every 8 seconds or so.

## Full Setup

The following instructions contain information for deploying the pipeline on a clean host system.

(Make sure nvidia drivers are installed and enabled on the docker host system)

### Ubuntu/Debian

#### Install Docker

```
sudo apt install -y docker-ce docker-ce-cli
```

#### Install Nvidia-Docker

```
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update
nvidia-container-runtime nvidia-docker2
sudo systemctl restart docker
```

#### Update Docker Default Runtime (Optional)

update /etc/docker/daemon.json for supporting legacy nvidia-docker scripts

```
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
         } 
    },
    "default-runtime": "nvidia"
}
```

### Arch/Manjaro

### Install Docker

```
pacman -S docker
```

#### Install Nvidia-Docker

```
pamac install libnvidia-container
pamac install libnvidia-container
pamac install libnvidia-container-tools
pamac install nvidia-container-toolkit
pamac install nvidia-container-runtime
```

#### Update Docker Default Runtime

update /etc/docker/daemon.json for supporting legacy nvidia-docker scripts

```
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
         } 
    },
    "default-runtime": "nvidia"
}
```

#### Handle CGroup V2

CGroup V2 is currently not supported with nvidia-container-toolkit


Either:

Disable CGroup
```
systemd.unified_cgroup_hierarchy=false
```

Use Priviliged Mode (unsecure)
```
docker --priviliged
```

See https://github.com/NVIDIA/libnvidia-container/issues/111

## Build Docker Image

Note: dockerfile building does not currently support executing cuda binaries. Make sure to not install any cuda drivers during this step.

```
docker build -t plasma-leap-receiver .
```

## Run and Test Pipeline

### Download sample data on host machine

```
cd ../samples/ska
bash install.sh
```

### Run docker image

```
cd leap-pipeline/plasma-leap/samples/ska
docker run -it --rm --gpus=all --shm-size=3000000000 --ipc=shareable \
--mount type=bind,src=$PWD,dst=/code/plasma-leap/samples/ska \
plasma-leap-receiver
```

### Test pipeline in docker container

```
nvidia-smi
cd /code/plasma-leap/samples/ska
bash ska.sh run_tmux
```
