#!/bin/bash

#TODO Merge to using something like this: https://github.com/philip-park/idv/blob/master/scripts/source-manager.sh

QEMU_VER=qemu-4.2.0

# Install libs
sudo apt install -y git libfdt-dev libpixman-1-dev libssl-dev vim socat libsdl2-dev libspice-server-dev autoconf libtool xtightvncviewer tightvncserver x11vnc uuid-runtime uuid uml-utilities bridge-utils python-dev liblzma-dev libc6-dev libegl1-mesa-dev libepoxy-dev libdrm-dev libgbm-dev libaio-dev libusb-1.0-0-dev libgtk-3-dev bison libcap-dev libattr1-dev flex libvirglrenderer-dev build-essential gettext libegl-mesa0 libegl-dev libglvnd-dev libgl1-mesa-dev libgl1-mesa-dev libgles2-mesa-dev libegl1 gcc g++ pkg-config libpulse-dev libgl1-mesa-dri

# For usb-redir
sudo apt install -y libusbredirhost-dev

if [[ -d $QEMU_VER ]]; then
    echo "Directory detected"
else
    echo "Downloading qemu"
    wget https://download.qemu.org/$QEMU_VER.tar.xz
    xvJf $QEMU_VER.tar.xz 
fi

#sudo apt install -y wget mtools ovmf dmidecode python3-usb python3-pyudev pulseaudio jq acpica-tools acpid bash
#
#    # Install libs for vm-manager
#    sudo apt install -y libglib2.0-dev libncurses-dev libuuid1 uuid-dev libjson-c-dev
#}
#
#function ubu_install_qemu_gvt(){
#    sudo apt purge -y "^qemu"
#    sudo apt autoremove -y
#
#QEMU_REL="qemu-4.2.0"
#
#    ./configure --prefix=/usr \
#        --enable-kvm \
#        --disable-xen \
#        --enable-libusb \
#        --enable-debug-info \
#        --enable-debug \
#        --enable-sdl \
#        --enable-vhost-net \
#        --enable-spice \
#        --disable-debug-tcg \
#        --enable-opengl \
#        --enable-gtk \
#        --enable-virtfs \
#        --target-list=x86_64-softmmu \
#        --audio-drv-list=pa
#    make -j24
#    sudo make install
#    cd -

cd $QEMU_VER
./configure --prefix=/usr \
 --enable-kvm \
 --disable-xen \
 --enable-libusb \
 --enable-debug-info \
 --enable-debug \
 --enable-sdl \
 --enable-vhost-net \
 --enable-spice \
 --disable-debug-tcg \
 --enable-opengl \
 --enable-gtk \
 --enable-virtfs \
 --target-list=x86_64-softmmu \
 --audio-drv-list=pa \
 --enable-usb-redir \
 --enable-virglrenderer \
 --enable-system \
 --enable-modules \

make -j $(nproc)
sudo make install -j $(nproc)

