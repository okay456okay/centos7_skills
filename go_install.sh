#!/bin/bash

tar zxf ~/Downloads/go1.11.linux-amd64.tar.gz -C /usr/local
export PATH=$PATH:/usr/local/go/bin
echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.bashrc
export GOPATH=~/go
echo 'export GOPATH=~/go' >>~/.bashrc
