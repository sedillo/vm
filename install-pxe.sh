#!/bin/bash

set -x

sudo virt-install \
  --name pxe-${NAME} \
  --ram=8192 \
  --vcpus=4 \
  --cpu host --hvm \
  --disk path=./disk/pxe-${NAME},size=20 \
  --network bridge=br0 \
  --pxe \
  --os-type=generic \
  --graphics vnc,port=${VNC_PORT} &

