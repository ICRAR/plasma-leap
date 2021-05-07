# Summary

plasma-leap-receiver is a container for calibrating on recieved observations by storing visibilities in an plasma in-memory data store then reading via leap-accelerate.
 

# Setup

## Ubuntu/Debian (Make sure nvidia drivers are enabled on the physical system)

```
# Add dependencies
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update
apt install -y docker-ce docker-ci-cli nvidia-container-toolkit nvidia-container-runtime

# Build Image

## update /etc/docker/daemon.json for building images with cuda runtime support enabled
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

docker build -t plasma-leap-receiver .

# Run Image
docker run -it -p 3000:3000 --gpus=all plasma-leap-receiver
```
