#!/bin/bash

# https://www.linuxtechi.com/enable-nested-virtualization-kvm-centos-7-rhel-7/
cat /sys/module/kvm_intel/parameters/nested
cat >/etc/modprobe.d/kvm-nested.conf  <<EOF
options kvm-intel nested=1
options kvm-intel enable_shadow_vmcs=1
options kvm-intel enable_apicv=1
options kvm-intel ept=1
EOF
modprobe -r kvm_intel
modprobe -a kvm_intel
cat /sys/module/kvm_intel/parameters/nested


# virsh edit "guestos" 
# cpu mode="host-model"
# in guest os, run: lscpu
