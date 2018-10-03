#!/bin/bash

# https://blog.csdn.net/wh211212/article/details/54141412
yum -y install qemu-kvm libvirt virt-install bridge-utils virt-manager

lsmod | grep kvm 

systemctl start libvirtd
systemctl enable libvirtd

