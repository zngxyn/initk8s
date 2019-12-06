#!/bin/bash
register_addr="192.168.245.135:5000"

docker pull shemg/k8s-repo:kube-apiserver-amd64_v1.10.11
docker pull shemg/k8s-repo:kube-scheduler-amd64_v1.10.11
docker pull shemg/k8s-repo:kube-controller-manager-amd64_v1.10.11
docker pull shemg/k8s-repo:kube-proxy-amd64_v1.10.11
docker pull shemg/k8s-repo:k8s-dns-kube-dns-amd64_1.14.8
docker pull shemg/k8s-repo:k8s-dns-dnsmasq-nanny-amd64_1.14.8
docker pull shemg/k8s-repo:k8s-dns-sidecar-amd64_1.14.8
docker pull shemg/k8s-repo:etcd-amd64_3.1.12
docker pull shemg/k8s-repo:flannel_v0.10.0-amd64
docker pull shemg/k8s-repo:pause-amd64_3.1
docker pull shemg/k8s-repo:kubernetes-dashboard-amd64_v1.10.0
docker pull shemg/k8s-repo:heapster-influxdb-amd64_v1.3.3
docker pull shemg/k8s-repo:heapster-grafana-amd64_v4.4.3
docker pull shemg/k8s-repo:heapster-amd64_v1.4.2
docker pull shemg/k8s-repo:calico_kube-controllers_v3.1.4
docker pull shemg/k8s-repo:calico_cni_v3.1.4
docker pull shemg/k8s-repo:calico_node_v3.1.4

docker tag shemg/k8s-repo:kube-apiserver-amd64_v1.10.11 $register_addr/kube-apiserver-amd64:v1.10.11
docker tag shemg/k8s-repo:kube-scheduler-amd64_v1.10.11 $register_addr/kube-scheduler-amd64:v1.10.11
docker tag shemg/k8s-repo:kube-controller-manager-amd64_v1.10.11 $register_addr/kube-controller-manager-amd64:v1.10.11
docker tag shemg/k8s-repo:kube-proxy-amd64_v1.10.11 $register_addr/kube-proxy-amd64:v1.10.11
docker tag shemg/k8s-repo:k8s-dns-kube-dns-amd64_1.14.8 $register_addr/k8s-dns-kube-dns-amd64:1.14.8 
docker tag shemg/k8s-repo:k8s-dns-dnsmasq-nanny-amd64_1.14.8 $register_addr/k8s-dns-dnsmasq-nanny-amd64:1.14.8 
docker tag shemg/k8s-repo:k8s-dns-sidecar-amd64_1.14.8 $register_addr/k8s-dns-sidecar-amd64:1.14.8 
docker tag shemg/k8s-repo:etcd-amd64_3.1.12 $register_addr/etcd-amd64:3.1.12 
docker tag shemg/k8s-repo:flannel_v0.10.0-amd64 $register_addr/flannel:v0.10.0-amd64 
docker tag shemg/k8s-repo:pause-amd64_3.1 $register_addr/pause-amd64:3.1 
docker tag shemg/k8s-repo:kubernetes-dashboard-amd64_v1.10.0 $register_addr/kubernetes-dashboard-amd64:v1.10.0
docker tag shemg/k8s-repo:heapster-influxdb-amd64_v1.3.3 $register_addr/heapster-influxdb-amd64:v1.3.3 
docker tag shemg/k8s-repo:heapster-grafana-amd64_v4.4.3 $register_addr/heapster-grafana-amd64:v4.4.3 
docker tag shemg/k8s-repo:heapster-amd64_v1.4.2 $register_addr/heapster-amd64:v1.4.2 
docker tag shemg/k8s-repo:calico_kube-controllers_v3.1.4 $register_addr/calico/kube-controllers:v3.1.4 
docker tag shemg/k8s-repo:calico_cni_v3.1.4 $register_addr/calico/cni:v3.1.4
docker tag shemg/k8s-repo:calico_node_v3.1.4 $register_addr/calico/node:v3.1.4

docker push $register_addr/kube-apiserver-amd64:v1.10.11
docker push $register_addr/kube-scheduler-amd64:v1.10.11
docker push $register_addr/kube-controller-manager-amd64:v1.10.11
docker push $register_addr/kube-proxy-amd64:v1.10.11
docker push $register_addr/k8s-dns-kube-dns-amd64:1.14.8 
docker push $register_addr/k8s-dns-dnsmasq-nanny-amd64:1.14.8 
docker push $register_addr/k8s-dns-sidecar-amd64:1.14.8 
docker push $register_addr/etcd-amd64:3.1.12 
docker push $register_addr/flannel:v0.10.0-amd64 
docker push $register_addr/pause-amd64:3.1 
docker push $register_addr/kubernetes-dashboard-amd64:v1.10.0
docker push $register_addr/heapster-influxdb-amd64:v1.3.3 
docker push $register_addr/heapster-grafana-amd64:v4.4.3 
docker push $register_addr/heapster-amd64:v1.4.2 
docker push $register_addr/calico/kube-controllers:v3.1.4 
docker push $register_addr/calico/cni:v3.1.4
docker push $register_addr/calico/node:v3.1.4