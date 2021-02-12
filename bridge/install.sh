#!/bin/bash

# https://ostechnix.com/install-and-configure-kvm-in-ubuntu-20-04-headless-server/
sudo apt-get update -y
sudo apt install -y qemu qemu-kvm libvirt-clients libvirt-daemon-system virtinst bridge-utils
sudo apt install -y zsync


# Check libvirtd
# sudo systemctl enable libvirtd
# sudo systemctl start libvirtd
# systemctl status libvirtd

# copy bridge file
sudo cp bridge.conf /etc/sysctl.d/bridge.conf
sudo cp 99-bridge.rules /etc/udev/rules.d/99-bridge.rules
