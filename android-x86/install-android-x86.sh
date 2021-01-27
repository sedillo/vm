#!/bin/bash

echo "Go here for overview of installation:"
echo "  https://www.wikigain.com/install-android-7-0-nougat-on-virtualbox/"
echo "Choose to run lineage OS at end of install"
echo "Don't connect to network"


qemu-system-x86_64 -enable-kvm \
    -name install \
    -boot menu=on,splash-time=5000 \
    -machine usb=on \
    -m 2G -smp 2 -cpu host \
    -M q35 \
    -net nic,model=e1000 \
    -net user \
    -cdrom "cm-x86_64-14.1-r4.iso" \
    -hda "android.qcow2" \
    -boot once=d \
    -device virtio-vga,virgl=on \
    -display sdl,gl=on


