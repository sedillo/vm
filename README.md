# vm

# Host OS Installation
```bash
git clone https://github.com/virt-manager/virt-manager
```

## Ubuntu VM 20.10 Desktop
```bash
sudo virt-install --name ubuntu-2010-desktop  \
  --ram=8192 --vcpus=4 \
  --cpu host --hvm \
  --disk path=/var/lib/libvirt/images/ubuntu-18.04-vm1,size=10 \
  --cdrom ./ubuntu-20.10-desktop-amd64.iso \
  --network bridge=br0 --graphics vnc
    
```
Open Remote viewer and connect to spice://127.0.0.1:5902
Install Ubuntu and hit enter when told to restart.
It should reboot into installed Ubuntu (i.e. it shouldn't ask you to install again

## Virsh Helpful Commands

### Install ESP
```bash
NAME=esp ./install-serial.sh
```
- Guided - Use entire disk
- Write changes to disk
- Install as normal, make sure to install OpenSSH-server package

Find the ESP IP address by using:
```bash
nmap -sP 192.168.17.0/24
```

Install ESP
```bash
sudo su -

mkdir -p /usr/local/bin
wget -O /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)"
chmod a+x /usr/local/bin/docker-compose

wget get.docker.io -O /tmp/docker-install.sh
chmod +x /tmp/docker-install.sh
/tmp/docker-install.sh

cd /opt
git clone -b master --depth=1 https://github.com/intel/Edge-Software-Provisioner.git esp
cd esp

./build.sh
./run.sh
```

### Launch Guest VM Using ESP
Install a VNC Client
- Windows: VNC Viewer
- Linux: Remmina

```bash
./install-pxe.sh
```
Then connect VNC Client to Port 5902 (or as defined in ./install-pxe.sh file)

### Shutdown and Undefine VM
```bash
virsh list --all
virsh shutdown <VM>
virsh undefine <VM>
```

## References
https://ostechnix.com/install-and-configure-kvm-in-ubuntu-20-04-headless-server/

https://blog.programster.org/kvm-cheatsheet
