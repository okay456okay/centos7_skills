#!/bin/bash

setenforce 0
systemctl stop firewalld

yum install -y epel-release
yum install -y aria2

mkdir -p /etc/aria2
cat >/etc/aria2/aria2.conf <<EOF
#用户名
#rpc-user=user
#密码
#rpc-passwd=passwd
#上面的认证方式不建议使用,建议使用下面的token方式
#设置加密的密钥
#rpc-secret=token
#允许rpc
enable-rpc=true
#允许所有来源, web界面跨域权限需要
rpc-allow-origin-all=true
#允许外部访问，false的话只监听本地端口
rpc-listen-all=true
#RPC端口, 仅当默认端口被占用时修改
rpc-listen-port=6800
#最大同时下载数(任务数), 路由建议值: 3
max-concurrent-downloads=5
#断点续传
continue=true
#同服务器连接数
max-connection-per-server=5
#最小文件分片大小, 下载线程数上限取决于能分出多少片, 对于小文件重要
min-split-size=10M
#单文件最大线程数, 路由建议值: 5
split=10
#下载速度限制
max-overall-download-limit=0
#单文件速度限制
max-download-limit=0
#上传速度限制
max-overall-upload-limit=0
#单文件速度限制
max-upload-limit=0
#断开速度过慢的连接
#lowest-speed-limit=0
#验证用，需要1.16.1之后的release版本
#referer=*
#文件保存路径, 默认为当前启动位置
dir=/root/downloads
#文件缓存, 使用内置的文件缓存, 如果你不相信Linux内核文件缓存和磁盘内置缓存时使用
#disk-cache=0
#另一种Linux文件缓存方式
#enable-mmap=true
#文件预分配, 能有效降低文件碎片, 提高磁盘性能. 缺点是预分配时间较长
file-allocation=prealloc
EOF

aria2c --conf-path=/etc/aria2/aria2.conf -D
sed '/aria2/d' /etc/rc.local
echo 'aria2c --conf-path=/etc/aria2/aria2.conf -D' >>/etc/rc.local

# http://aria2c.com/
echo "WEBUI: http://aria2c.com/"

# yum install -y git httpd
# git clone https://github.com/ziahamza/webui-aria2
# cp -a webui-aria2/docs /var/www/html/aria2
# chown -R apache.apache /var/www/html/aria2

# systemctl start httpd
