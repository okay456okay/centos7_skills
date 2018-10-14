#!/bin/bash

# Prerequirements
# helm binary package
tar zxf helm-v2.11.0-linux-amd64.tar.gz
cp linux-amd64/helm /usr/local/bin
cp linux-amd64/tiller /usr/local/bin
cat >rbac-config.yaml <<'EOF'
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
EOF
kubectl create -f rbac-config.yaml
helm init --upgrade --service-account tiller -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.11.0 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
helm repo update
helm search
