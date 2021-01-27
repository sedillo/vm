#!/bin/bash

wget https://osdn.net/dl/android-x86/cm-x86_64-14.1-r4.iso
qemu-img create -f qcow2 android.qcow2 20G
