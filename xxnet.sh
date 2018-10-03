#!/bin/bash


yum install -y epel-release
yum install -y http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm

yum  install -y miredo

systemctl enable miredo-client
systemctl start  miredo-client

cd /root/Downloads/XX-Net-3.12.11  && ./xx_net.sh


echo 'cd /root/Downloads/XX-Net-3.12.11  && ./xx_net.sh' >>/etc/rc.local
