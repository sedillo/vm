#!/bin/bash

sudo virt-install \
  --name ubuntu-${NAME} \
  --ram=2048 \
  --vcpus=2 \
  --cpu host --hvm \
  --disk path=./disk/ubuntu-${NAME},size=20 \
  --cdrom ./iso/ubuntu-20.10-live-server-amd64.iso \
  --network bridge=br0 \
  --os-type=generic \
  --graphics vnc,port=${VNC_PORT} &
