#!/bin/bash

set -x

sudo virt-install \
  --name port-and-amt \
  --ram=8192 \
  --vcpus=4 \
  --cpu host --hvm \
  --disk path=./disk/port-and-amt-vm1,size=100 \
  --network bridge=br0 \
  --pxe \
  --os-type=generic \
  --graphics vnc,port=5902 &
