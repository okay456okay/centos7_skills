#!/bin/bash

# set hostname


# https://blog.csdn.net/zyl290760647
# https://kubernetes.io/docs/setup/independent/install-kubeadm/
ifconfig -a
cat /sys/class/dmi/id/product_uuid
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum list docker-ce --showduplicates | sort -r
yum install -y docker-ce
systemctl start docker
systemctl status docker
systemctl enable docker
cat >/etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://2pj1hreq.mirror.aliyuncs.com"]
}
EOF
cat /etc/docker/daemon.json
docker run hello-world
setenforce 0
cat >/etc/yum.repos.d/kubernetes.repo  <<EOF
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
       http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable kubelet && systemctl start kubelet

swapoff -a
iptables -P FORWARD ACCEPT
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
vm.swappiness=0
EOF
sysctl --system

DOCKER_CGROUPS=$(docker info | grep 'Cgroup' | cut -d' ' -f3)
echo $DOCKER_CGROUPS
 
cat >/etc/sysconfig/kubelet<<EOF
KUBELET_EXTRA_ARGS="--cgroup-driver=$DOCKER_CGROUPS --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1"
EOF
 
# 启动
systemctl daemon-reload
systemctl enable kubelet && systemctl restart kubelet

sed -i '/swap/s/^/#/g' /etc/fstab 

# images list
# kubeadm config images list --kubernetes-version 1.12.0
# https://blog.csdn.net/jinguangliu/article/details/82792617
images=$(kubeadm config images list --kubernetes-version 1.12.0|grep -v coredns| awk -F'/' '{print $NF}' |tr '\n' ' '|sed 's/\s\+$//')
for image in  $images; do
    docker pull mirrorgooglecontainers/$image
    docker tag docker.io/mirrorgooglecontainers/$image  k8s.gcr.io/$image
    docker rmi docker.io/mirrorgooglecontainers/$image
done
coredns_image=$(kubeadm config images list --kubernetes-version 1.12.0|grep coredns|awk -F'/' '{print $NF}')
docker pull coredns/$coredns_image
docker tag docker.io/coredns/$coredns_image  k8s.gcr.io/$coredns_image
docker rmi docker.io/coredns/$coredns_image

# master
kubeadm init --kubernetes-version=v1.12.0 --pod-network-cidr=10.244.0.0/16

# kubeadm join 192.168.122.130:6443 --token n6dnqh.ik7nyjie17txtc38 --discovery-token-ca-cert-hash sha256:a637af736a0c46e572812ecfdd40ce19f38168da40c908c36ecd6d4f725711ef
# 对于非root用户
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
 
# 对于root用户
export KUBECONFIG=/etc/kubernetes/admin.conf
# 也可以直接放到~/.bash_profile（推荐用这个命令）
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile

kubectl taint nodes --all node-role.kubernetes.io/master-

# mkdir flannel && cd flannel
# wget https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml
# kubectl apply -f kube-flannel.yml
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
