#!/bin/bash
#docker镜像仓库地址
register_addr="59.61.92.150:8888"
#local_ip=$(ip addr | grep ens | grep inet | awk '{print $2}'|awk -F '/' '{print $1}')
if [ "$1" = "" ]; then
	echo "请输入参数1（节点hostname，命名需满足DNS规则，不能包含下划线，不能为localhost)"
elif [ "$2" = "" ]; then
	echo "请输入参数2（本机IP）："
else
	yum -y install ntp ntpdate
	ntpdate cn.pool.ntp.org
	hwclock --systohc

	local_ip=$2
	chmod -R +x *
	mkdir -p /data/ent/docker /data/ent/kubernetes
	cp docker-ce.repo /etc/yum.repos.d
	cp kubernetes.repo /etc/yum.repos.d
	hostnamectl --static set-hostname $1
	systemctl disable firewalld.service
	systemctl stop firewalld.service
	echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/k8s.conf
	sysctl -p /etc/sysctl.d/k8s.conf
	yum install -y yum-utils device-mapper-persistent-data lvm2 bash-completion
	yum makecache fast
	yum install -y --setopt=obsoletes=0 docker-ce-17.12.1.ce-1.el7.centos
	iptables -P FORWARD ACCEPT
	sed -i "s#.*ExecStart=/usr/bin/dockerd.*#ExecStart=/usr/bin/dockerd --insecure-registry $register_addr#gi" /usr/lib/systemd/system/docker.service
	systemctl enable docker && systemctl start docker
	swapoff -a
	sed -i "s#59.61.92.150:8888#$register_addr#" init_k8s_master_images.sh
	docker login -u gnwpubdev -p pubdev888 59.61.92.150:8888
	bash init_k8s_master_images.sh
	yum install -y kubernetes-cni-0.6.0 kubelet-1.10.11 kubeadm-1.10.11 kubectl-1.10.11 
	sed -i "s#--cgroup-driver=systemd#--cgroup-driver=cgroupfs#" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
	echo 'Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"' >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
	systemctl enable kubelet && systemctl start kubelet 
	kubeadm init --kubernetes-version=v1.10.11 --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/16 --apiserver-advertise-address=$local_ip --ignore-preflight-errors=all
	echo "join command do not forget add this: --ignore-preflight-errors=all"
	echo "join cluster kubeadm token(ttl 0):" && kubeadm token create --ttl 0
	mkdir -p $HOME/.kube
	cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	chown $(id -u):$(id -g) $HOME/.kube/config
	#设置calico网络
	#sed -i 's@.*etcd_endpoints:.*@\ \ etcd_endpoints:\ \"http://'$local_ip':2379\"@gi' calico.yaml
	sed -i "s#59.61.92.150:8888#$register_addr#" calico/init_calico_images.sh
	bash calico/init_calico_images.sh
	kubectl apply -f calico/rbac.yaml
	kubectl apply -f calico/calico.yaml
	#设置DNS
	kubectl create -f dns/kube-dns.yaml
	#安装heapster监控组件
	sed -i "s#59.61.92.150:8888#$register_addr#" heapster/k8s-heapster.sh
	bash heapster/k8s-heapster.sh
	kubectl create -f heapster/
	#创建dashboard
	kubectl apply -f dashboard/kubernetes-dashboard.yaml
	kubectl create -f dashboard/kubernetes-dashboard-admin.rbac.yaml
	kubectl patch svc kubernetes-dashboard -p '{"spec":{"type":"NodePort"}}' -n kube-system
	echo "dashboard管理后台地址：""https://"$local_ip":"$(kubectl get svc -n kube-system -owide | grep kubernetes-dashboard | awk '{print $5}' | sed 's#443:##' | sed 's#/TCP##')
	echo "dashboard管理后台登录token：" && kubectl describe secret | grep token:
	kubectl create clusterrolebinding --user system:serviceaccount:default:default default-sa-admin --clusterrole cluster-admin	
	#配置kubectl命令自动补全
	source /usr/share/bash-completion/bash_completion
	source <(kubectl completion bash)
fi
