# Plasma-Leap-Pipeline Docker Image

## Summary

plasma-leap-receiver is a container including the entire pipeline for leap calibrating using observations recieved observations by storing visibilities in an plasma in-memory data store then reading via leap-accelerate.

### Pipeline Diagram

![pipeline-diagram](/images/mem-workflow.jpg "Plasma-Leap Pipeline")

## Install Nvidia-Docker

(Make sure nvidia drivers are installed and enabled on the docker host system)

### Ubuntu/Debian

#### Install Docker

```
sudo apt install -y docker-ce docker-ci-cli
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

## Update Docker default runtime

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

## Build Image

Note: dockerfile building does not currently support executing cuda code

```
docker build -t plasma-leap-receiver .
```

## Run and Test Image

```
docker run -it -p 3000:3000 --gpus=all --shm-size=3000000000 --ipc=shareable plasma-leap-receiver
nvidia-smi
cd /code/plasma-leap/samples/ska
bash install.sh
bash ska.sh run_tmux
```

Upon running it should be observed that LeapAccelerateCLI is called in the right tmux window and outputs a calibration array of numbers every 8 seconds or so.
