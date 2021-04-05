# vm

This guide will show you how to set up a 
- Virsh and KVM to launch VMs on the host OS
- Launch guest VMs
- Build Guest ESP on top of virsh

Prerequisites
- Ubuntu Server 20.04 Host OS
- OpenSSH enabled
- Host exists on subnet behind a router
- External access to the internet

## Host OS - Ubuntu Server 20.04 Configuration
Reference from: https://ostechnix.com/install-and-configure-kvm-in-ubuntu-20-04-headless-server/

### Install libs
```bash
git -C ~ clone git@github.com:sedillo/vm.git

sudo apt install -y qemu qemu-kvm libvirt-clients libvirt-daemon-system virtinst bridge-utils
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
systemctl status libvirtd

IP_ADDRESS=$(ip route get 1.2.3.4 | awk '{printf "%s" , $7}')
IP_GATEWAY=$(ip route get 1.2.3.4 | awk '{printf "%s" , $7}')

cd ~/vm/bridge/
./install.sh
sudo reboot
```

### Network bridge
Destroy default network bridge
```bash
virsh net-destroy default
virsh net-undefine default

# If the above commands don't work you can try these
# sudo ip link delete virbr0 type bridge
# sudo ip link delete virbr0-nic
```

Define new network bridge with $IP_ADDRESS and $IP_GATEWAY in file ~/vm/bridge/00-install-config.yaml
```yaml
# This is the network config written by 'subiquity'
network:
  ethernets:
    eno1:
      dhcp4: false
      dhcp6: false
  bridges:
    br0:
      interfaces: [ eno1 ]
      addresses: [${IP_ADDRESS}/24]
      gateway4: ${IP_GATEWAY}
      mtu: 1500
      nameservers:
        addresses: [8.8.8.8,8.8.4.4]
      parameters:
        stp: true
        forward-delay: 4
      dhcp4: no
      dhcp6: no
  version: 2
```
Start bridge
```bash
sudo cp /etc/netplan/00-installer-config.yaml{,.backup}
sudo cp 00-installer-config.yaml /etc/netplan/00-installer-config.yaml
sudo netplan --debug  apply
```
Verify bridge exists
```bash
brctl show br0
```
Set KVM to use br0 bridge
```bash
#verify nothing exists
virsh net-list --all

#Apply changes
cd ~/vm/bridge
virsh net-define host-bridge.xml
virsh net-start host-bridge
virsh net-autostart host-bridge

#Verify changes worked
virsh net-list --all
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

https://blog.programster.org/kvm-cheatsheet

### TODO: Update virt-manager
```bash
git clone https://github.com/virt-manager/virt-manager
```

