#!/bin/bash

echo "Go to top right settings"
echo "And make sure virt-wifi is selected to access internet"

qemu-system-x86_64 -enable-kvm \
    -name install \
    -boot menu=on,splash-time=5000 \
    -machine usb=on \
    -m 2G -smp 2 -cpu host \
    -M q35 \
    -net nic,model=e1000 \
    -net user \
    -hda "android.qcow2" \
    -device virtio-vga,virgl=on \
    -display sdl,gl=on

# Some android distributions will not boot and 
# leave you at here: consolee:/ #
# You can try removing this line to fix
#    -device virtio-vga,virgl=on \
