#!/bin/bash

# just for demo
cd ~/prometheus
./prometheus &
cd $GOPATH/bin
./random -listen-address=:8080 &
./random -listen-address=:8081 &
./random -listen-address=:8082 &
