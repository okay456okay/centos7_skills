#!/bin/bash

yum install -y git
git clone https://github.com/containous/traefik.git
cd traefik/examples/k8s
kubectl create -f traefik-rbac.yaml 
kubectl create -f traefik-deployment.yaml 
kubectl get service --all-namespaces
kubectl get pods --all-namespaces -o wide
# use nodeport to access dashhboard, 8080 is dashboard port
