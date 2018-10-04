#!/bin/bash

yum -y install epel-release
yum -y install ntfs-3g
mkdir -p /run/media/{SOFTWARE,DATA}
echo '/dev/sdb1 /run/media/SOFTWARE                    ntfs-3g    defaults        0 0' >>/etc/fstab
echo '/dev/sdb5 /run/media/DATA                    ntfs-3g    defaults        0 0'>>/etc/fstab
mount -a

