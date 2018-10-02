#!/bin/bash

setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
systemctl stop firewalld
systemctl disable firewalld

# yum update -y

yum install -y epel-release

yum install -y ntfs-3g
grub2-mkconfig -o /boot/grub2/grub.cfg
