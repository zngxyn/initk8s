#!/bin/bash

register_addr="59.61.92.150:8888"
if [ "$1" = "" ]; then
	echo "请输入hostname"
else
    yum -y install ntp ntpdate
	ntpdate cn.pool.ntp.org
	hwclock --systohc
	
	chmod -R +x *
	mkdir -p /data/ent/docker /data/ent/kubernetes
	cp docker-ce.repo /etc/yum.repos.d
	cp kubernetes.repo /etc/yum.repos.d
	hostnamectl --static set-hostname $1
	systemctl disable firewalld.service
	systemctl stop firewalld.service
	echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/k8s.conf
	sysctl -p /etc/sysctl.d/k8s.conf
	yum install -y yum-utils device-mapper-persistent-data lvm2
	yum makecache fast
	yum install -y --setopt=obsoletes=0 docker-ce-17.12.1.ce-1.el7.centos
	iptables -P FORWARD ACCEPT
	sed -i "s#.*ExecStart=/usr/bin/dockerd.*#ExecStart=/usr/bin/dockerd --insecure-registry $register_addr#gi" /usr/lib/systemd/system/docker.service
	systemctl enable docker && systemctl start docker
	swapoff -a
	sed -i "s#59.61.92.150:8888#$register_addr#" init_k8s_node_images.sh
	docker login -u gnwpubdev -p pubdev888 59.61.92.150:8888
	bash init_k8s_node_images.sh
	sed -i "s#59.61.92.150:8888#$register_addr#" calico/init_calico_images.sh
	bash calico/init_calico_images.sh
	yum install -y kubernetes-cni-0.6.0 kubelet-1.10.11 kubeadm-1.10.11 kubectl-1.10.11
	sed -i "s#--cgroup-driver=systemd#--cgroup-driver=cgroupfs#" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
	echo 'Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"' >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
	systemctl enable kubelet && systemctl start kubelet 
	echo "请输入从master节点初始化得到的join命令："
	#kubeadm join 192.168.245.141:6443 --token i5nul8.r0yvid0o0i6q7fa8 --discovery-token-ca-cert-hash sha256:33b2989161f8e561f70d3be2b515e2a10a6a37e45b2c174818170ee710b0bccc --ignore-preflight-errors=all
fi
