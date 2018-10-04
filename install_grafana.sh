#!/bin/bash

cat >/etc/yum.repos.d/grafana.repo <<'EOF'
[grafana]
name=grafana
baseurl=https://mirrors.tuna.tsinghua.edu.cn/grafana/yum/el7
repo_gpgcheck=0
gpgcheck=0
enabled=1
EOF
yum install grafana
yum install fontconfig
yum install freetype*
yum install urw-fonts
systemctl daemon-reload
systemctl start grafana-server
systemctl status grafana-server
systemctl enable grafana-server

# http://localhost:3000/
