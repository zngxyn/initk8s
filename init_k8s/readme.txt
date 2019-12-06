运行服务器：centos7
备注：服务器节点hostname命名需满足DNS规则，不能包含下划线

初始化镜像仓库节点
./init_register.sh | tee init.log

初始化master节点
修改init_master.sh的local_ip为本机ip、register_addr为镜像仓库地址
./init_master.sh 节点主机名 本机ip | tee init.log

初始化node节点
./init_node.sh 节点主机名 | tee init.log

配置独占节点：
kubectl label nodes k8s-node-247-111 flag=k8s-push
kubectl taint nodes k8s-node-247-111 pushapp=true:NoSchedule

删除节点：
#node62为节点名
master执行：
kubectl drain node62 --delete-local-data --ignore-daemonsets
kubectl delete node node62
节点node62执行：
kubeadm reset

批量删除pod
kubectl get pods | grep gnw | awk '{print $1}' | xargs kubectl delete pod

强制删除pod
kubectl delete pod PODNAME --force --grace-period=0

master创建集群：
kubeadm init --kubernetes-version=v1.10.11 --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.245.132 --ignore-preflight-errors=all
mode入集群：
kubeadm join 172.168.50.89:6443 --token pdoah3.wzu2covyhhhxsuov --discovery-token-ca-cert-hash sha256:9ca327fca75b25adf2afde07de096aa1140727db17595082679bc32e4ed6961c  --ignore-preflight-errors=all


查看kubelet状态：systemctl status kubelet
查看kubelet运行日志：journalctl -xefu kubelet
查看docker cgroup driver：docker info | grep Cgroup

重置kubeadm：kubeadm reset
启动kubelet：systemctl start kubelet
