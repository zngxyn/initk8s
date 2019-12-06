#!/bin/bash

echo "============开始安装k8s============"

# 下载k8s docker镜像
docker login -u gnwpubdev -p pubdev888 59.61.92.150:8888

docker pull 59.61.92.150:8888/kube-apiserver-amd64:v1.10.11
docker pull 59.61.92.150:8888/kube-scheduler-amd64:v1.10.11
docker pull 59.61.92.150:8888/kube-controller-manager-amd64:v1.10.11
docker pull 59.61.92.150:8888/kube-proxy-amd64:v1.10.11
docker pull 59.61.92.150:8888/k8s-dns-kube-dns-amd64:1.14.8 
docker pull 59.61.92.150:8888/k8s-dns-dnsmasq-nanny-amd64:1.14.8 
docker pull 59.61.92.150:8888/k8s-dns-sidecar-amd64:1.14.8 
docker pull 59.61.92.150:8888/etcd-amd64:3.1.12 
docker pull 59.61.92.150:8888/coreos/flannel:v0.10.0-amd64 
docker pull 59.61.92.150:8888/pause-amd64:3.1 
docker pull 59.61.92.150:8888/kubernetes-dashboard-amd64:v1.10.0

docker tag 59.61.92.150:8888/kube-apiserver-amd64:v1.10.11 k8s.gcr.io/kube-apiserver-amd64:v1.10.11
docker tag 59.61.92.150:8888/kube-scheduler-amd64:v1.10.11 k8s.gcr.io/kube-scheduler-amd64:v1.10.11
docker tag 59.61.92.150:8888/kube-controller-manager-amd64:v1.10.11 k8s.gcr.io/kube-controller-manager-amd64:v1.10.11
docker tag 59.61.92.150:8888/kube-proxy-amd64:v1.10.11 k8s.gcr.io/kube-proxy-amd64:v1.10.11
docker tag 59.61.92.150:8888/k8s-dns-kube-dns-amd64:1.14.8 k8s.gcr.io/k8s-dns-kube-dns-amd64:1.14.8 
docker tag 59.61.92.150:8888/k8s-dns-dnsmasq-nanny-amd64:1.14.8 k8s.gcr.io/k8s-dns-dnsmasq-nanny-amd64:1.14.8 
docker tag 59.61.92.150:8888/k8s-dns-sidecar-amd64:1.14.8 k8s.gcr.io/k8s-dns-sidecar-amd64:1.14.8 
docker tag 59.61.92.150:8888/etcd-amd64:3.1.12 k8s.gcr.io/etcd-amd64:3.1.12 
docker tag 59.61.92.150:8888/coreos/flannel:v0.10.0-amd64 quay.io/coreos/flannel:v0.10.0-amd64 
docker tag 59.61.92.150:8888/pause-amd64:3.1 k8s.gcr.io/pause-amd64:3.1
docker tag 59.61.92.150:8888/kubernetes-dashboard-amd64:v1.10.0 k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.0
echo "============下载k8s docker镜像done"

docker pull 59.61.92.150:8888/calico/kube-controllers:v3.1.4 
docker pull 59.61.92.150:8888/calico/cni:v3.1.4
docker pull 59.61.92.150:8888/calico/node:v3.1.4

docker tag 59.61.92.150:8888/calico/kube-controllers:v3.1.4 quay.io/calico/kube-controllers:v3.1.4
docker tag 59.61.92.150:8888/calico/cni:v3.1.4 quay.io/calico/cni:v3.1.4
docker tag 59.61.92.150:8888/calico/node:v3.1.4 quay.io/calico/node:v3.1.4
echo "============下载calico docker镜像done"

# 安装k8s
yum install -y kubernetes-cni-0.6.0 kubelet-1.10.11 kubeadm-1.10.11 kubectl-1.10.11
echo "============yum安装k8s done"

# 配置k8s
sed -i "s#--cgroup-driver=systemd#--cgroup-driver=cgroupfs#" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
echo 'Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"' >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
# 启动k8s服务
systemctl enable kubelet && systemctl start kubelet
echo "============配置并启动k8s done"

#配置kubectl命令自动补全
yum install -y bash-completion
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)


echo "============完成安装k8s============"
