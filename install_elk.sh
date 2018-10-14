#!/bin/bash

# Refer URL: https://www.cnblogs.com/straycats/p/8053937.html

rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat >/etc/yum.repos.d/elk.repo <<'EOF'
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

# Downloads URL: https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
yum install jdk-8u181-linux-x64.rpm 
yum -y install logstash kibana
yum -y install elasticsearch
yum -y install net-tools

cat >>/etc/elasticsearch/elasticsearch.yml <<'EOF'
#设置内存不使用交换分区
bootstrap.memory_lock: false
#配置了bootstrap.memory_lock为true时反而会引发9200不会被监听，原因不明

#设置允许所有ip可以连接该elasticsearch
network.host: 0.0.0.0

#开启监听的端口为9200
http.port: 9200

#增加新的参数，为了让elasticsearch-head插件可以访问es (5.x版本，如果没有可以自己手动加)
http.cors.enabled: true
http.cors.allow-origin: "*"
EOF

systemctl start elasticsearch
sleep 15
curl http://127.0.0.1:9200

cat >>/etc/logstash/logstash.yml <<'EOF'
# 设置管道配置文件路径为/etc/logstash/conf.d
path.config: /etc/logstash/conf.d
EOF
systemctl start logstash
# test
# /usr/share/logstash/bin/logstash -e 'input { stdin { } } output elasticsearch { hosts => ["127.0.0.1:9200"] } stdout { codec => rubydebug }}'

cat >>/etc/kibana/kibana.yml <<EOF
#kibana页面映射在5601端口
server.port: 5601

#允许所有ip访问5601端口
server.host: "0.0.0.0"

#elasticsearch所在的ip及监听的地址
elasticsearch.url: "http://localhost:9200"

kibana.index: ".kibana"
EOF

systemctl start kibana
sleep 15
curl http://localhost:5601
