#!/bin/bash

sudo virt-install \
  --name ubuntu-2010-desktop \
  --ram=8192 \
  --vcpus=4 \
  --cpu host --hvm \
  --disk path=./disk/ubuntu-2010-desktop-vm1,size=100 \
  --cdrom ./iso/ubuntu-20.10-desktop-amd64.iso \
  --network bridge=br0 \
  --graphics vnc,port=5900 &
