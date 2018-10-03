#!/bin/bash

new_hostname=$1
echo "$new_hostname" >/etc/hostname
hostname $new_hostname
eth0_ip=$(ifconfig eth0 |grep -P '^\s*inet\s+[\d.]+'|awk '{print $2}')
echo "$eth0_ip $new_hostname" >>/etc/hosts
