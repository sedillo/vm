#!/bin/bash

sudo virt-install \
  --name ubuntu-2010-server \
  --ram=8192 \
  --vcpus=4 \
  --cpu host --hvm \
  --disk path=./disk/ubuntu-2010-server-vm1,size=100 \
  --cdrom ./iso/ubuntu-20.10-live-server-amd64.iso \
  --network bridge=br0 \
  --os-type=generic \
  --graphics vnc,port=5901
