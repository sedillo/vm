#!/bin/bash

sudo virt-install \
--name ubuntu2004 \
--ram 4096 \
--disk path=./disk/ubuntu-2010-server-vm1,size=100 \
--vcpus 2 \
--os-type linux \
--os-variant ubuntu20.04 \
--network bridge=br0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/' \
--extra-args 'console=ttyS0,115200n8 serial'

