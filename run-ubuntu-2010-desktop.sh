#!/bin/bash

sudo virt-install \
  --name ubuntu-desktop-${NAME} \
  --ram=8192 \
  --vcpus=4 \
  --boot hd \
  --cpu host --hvm \
  --disk path=./disk/ubuntu-desktop-${NAME},size=20 \
  --network bridge=br0 \
  --graphics vnc,port=${VNC_PORT} &
