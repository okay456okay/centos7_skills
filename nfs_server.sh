#!/bin/bash


setenforce 0
systemctl stop firewalld

yum install -y nfs-utils
mkdir -p /var/nfs
chmod -R 766 /var/nfs
echo '/var/nfs 192.168.122.0/24(rw,sync,no_root_squash,no_all_squash)' >/etc/exports
exportfs -r
systemctl enable rpcbind
systemctl enable nfs-server
systemctl start rpcbind
systemctl start nfs-server
showmount -e localhost
