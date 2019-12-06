#!/bin/bash

local_ip=172.168.50.105

echo "============开始初始化master============"

# 初始化k8s
kubeadm init --kubernetes-version=v1.10.11 --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/16 --apiserver-advertise-address=$local_ip --ignore-preflight-errors=all
echo "============初始化k8s done"

# 启动之后有提示需要执行以下脚本
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 生产一个永久token
kubeadm token create --ttl 0
# 查看所有token
kubeadm token list

kubectl apply -f calico/rbac.yaml
kubectl apply -f calico/calico.yaml
echo "============设置calico done"

kubectl create -f dns/kube-dns.yaml
echo "============设置dns done"

docker login -u gnwpubdev -p pubdev888 59.61.92.150:8888

docker pull 59.61.92.150:8888/heapster-influxdb-amd64:v1.3.3
docker pull 59.61.92.150:8888/heapster-grafana-amd64:v4.4.3
docker pull 59.61.92.150:8888/heapster-amd64:v1.4.2

docker tag 59.61.92.150:8888/heapster-influxdb-amd64:v1.3.3 k8s.gcr.io/heapster-influxdb-amd64:v1.3.3
docker tag 59.61.92.150:8888/heapster-grafana-amd64:v4.4.3 k8s.gcr.io/heapster-grafana-amd64:v4.4.3
docker tag 59.61.92.150:8888/heapster-amd64:v1.4.2 k8s.gcr.io/heapster-amd64:v1.4.2
echo "============下载heapster docker镜像done"

kubectl create -f heapster/
echo "============设置heapster done"


#创建dashboard
kubectl apply -f dashboard/kubernetes-dashboard.yaml
kubectl create -f dashboard/kubernetes-dashboard-admin.rbac.yaml
kubectl patch svc kubernetes-dashboard -p '{"spec":{"type":"NodePort"}}' -n kube-system
echo "dashboard管理后台地址：""https://"$local_ip":"$(kubectl get svc -n kube-system -owide | grep kubernetes-dashboard | awk '{print $5}' | sed 's#443:##' | sed 's#/TCP##')
echo "dashboard管理后台登录token：" && kubectl describe secret | grep token:
kubectl create clusterrolebinding --user system:serviceaccount:default:default default-sa-admin --clusterrole cluster-admin	
echo "============设置doshboard done"

echo "============完成初始化master============"
