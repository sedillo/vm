#!/bin/bash

sudo virt-install \
  --name ubuntu-desktop-${NAME} \
  --ram=8192 \
  --vcpus=4 \
  --cpu host --hvm \
  --disk path=./disk/ubuntu-desktop-${NAME},size=20 \
  --cdrom ./iso/ubuntu-20.10-desktop-amd64.iso \
  --network bridge=br0 \
  --graphics vnc,port=${VNC_PORT} &
