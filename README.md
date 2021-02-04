# vm

## Ubuntu VM 20.10 Desktop
```bash
sudo apt-get install -y zsync
zsync http://releases.ubuntu.com/20.10/ubuntu-20.10-desktop-amd64.iso.zsync

sudo apt -y install virt-viewer
docker run \
    --privileged \
    --net=host \
    -v /dev:/dev \
    -v /mnt:/data/volumes \
    -v ${PWD}:${PWD} \
    -e RAM=12288 \
    -e SMP=4,sockets=4,cores=1,threads=1 \
    -e IMAGE=${PWD}/ubuntu2010.qcow2 \
    -e IMAGE_CREATE=1 \
    -e ISO=${PWD}/ubuntu-20.10-desktop-amd64.iso \
    -e VIDEO=spice -e SPICE=tcp -e SPICE_IP=127.0.0.1 -e SPICE_PORT=5902 \
    -p 5902:5902 \
    -p 2222:22 \
    -p 8080:80 \
    -p 5900:5900 \
    rrp/kvm
    
```
Open Remote viewer and connect to spice://127.0.0.1:5902
Install Ubuntu and hit enter when told to restart.
It should reboot into installed Ubuntu (i.e. it shouldn't ask you to install again
