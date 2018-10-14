#!/bin/bash


setenforce 0
systemctl stop firewalld

yum install -y nfs-utils
systemctl enable rpcbind
systemctl start rpcbind

mkdir /var/nfs
mount -t nfs 192.168.122.131:/var/nfs /var/nfs
echo '192.168.122.131:/var/nfs /var/nfs nfs nolock  0 0' >>/etc/fstab
