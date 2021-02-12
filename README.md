# vm

## Ubuntu VM 20.10 Desktop
```bash
sudo virt-install --name ubuntu-2010-desktop  \
  --ram=8192 --vcpus=4 \
  --cpu host --hvm \
  --disk path=/var/lib/libvirt/images/ubuntu-18.04-vm1,size=10 \
  --cdrom ./ubuntu-20.10-desktop-amd64.iso \
  --network bridge=br0 --graphics vnc
    
```
Open Remote viewer and connect to spice://127.0.0.1:5902
Install Ubuntu and hit enter when told to restart.
It should reboot into installed Ubuntu (i.e. it shouldn't ask you to install again

## References
https://ostechnix.com/install-and-configure-kvm-in-ubuntu-20-04-headless-server/

https://blog.programster.org/kvm-cheatsheet
