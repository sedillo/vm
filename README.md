# VM - Virtual Machine Setup

This guide will show you how to set up a 
- Virsh and KVM to launch VMs on the host OS
- Launch guest VMs (like ESP)

Prerequisites
- Ubuntu Server 20.04 Host OS
- OpenSSH enabled
- Host exists on subnet behind a router
- External access to the internet

## Host OS - Virsh and KVM setup
Reference from: https://ostechnix.com/install-and-configure-kvm-in-ubuntu-20-04-headless-server/

### Install libs
```bash
git -C ~ clone git@github.com:sedillo/vm.git

sudo apt install -y qemu qemu-kvm libvirt-clients libvirt-daemon-system virtinst bridge-utils

#Open the file /etc/libvirt/qemu.conf
sudo vi /etc/libvirt/qemu.conf
#And uncommment this line
vnc_listen = "0.0.0.0"

sudo systemctl stop libvirtd
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
systemctl status libvirtd

IP_ADDRESS=$(ip route get 1.2.3.4 | awk '{printf "%s" , $7}')
IP_GATEWAY=$(ip route get 1.2.3.4 | awk '{printf "%s" , $3}')

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

## Downloading ISOs
Some scripts already exist for downloading most up-to-date ISOs zsync

For example, do this for ESP
```bash
cd ~/vm/iso
./download-ubuntu-2010-server.sh
```
## Launch VM
Using a tool like remmina or VNC Viewer open a VNC viewer to ${IP_ADDRESS}:5901
```bash
./install-esp.sh
```
- Continue without Updating
- IMPORTANT
-   make sure the network connection gets an IP from your subnet 
-   And make sure you remember the IP address
- Guided - Use entire disk
- Write changes to disk
- Install as normal, make sure to install OpenSSH-server package
- Don't install any extra package
- Let the security update finish
- VNC Viewer should autmatically reboot into the harddisk

## Install ESP on VM

Log in to ESP with 
```bash
ssh ${USER}@{ESP_ADDRESS}
#If you forgot the IP you can scan with this
#nmap -sP 192.168.17.0/24
```

Install ESP
```bash
# become super user
sudo su -

# Install docker and compose
mkdir -p /usr/local/bin
wget -O /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)"
chmod a+x /usr/local/bin/docker-compose

wget get.docker.io -O /tmp/docker-install.sh
chmod +x /tmp/docker-install.sh
/tmp/docker-install.sh
docker ps

# Download and build ESP
cd /opt
git clone -b master --depth=1 https://github.com/intel/Edge-Software-Provisioner.git esp
cd esp
./build.sh

# Run using this command
./run.sh
```

## Launch a second VM to boot from ESP VM
```bash
./install-pxe.sh
```
Then connect VNC Client to Port 5902 (or as defined in ./install-pxe.sh file)

## Launch Physical device from ESP VM
To do this just plug physical device into network with ESP VM on it

Hit specificied function key to go into boot menu and choose Network IPV4 PXE Boot

## References
https://docs.fedoraproject.org/en-US/Fedora/18/html/Virtualization_Administration_Guide/chap-Virtualization_Administration_Guide-Managing_guests_with_virsh.html

https://blog.programster.org/kvm-cheatsheet

### TODO: Update virt-manager
```bash
git clone https://github.com/virt-manager/virt-manager
```

