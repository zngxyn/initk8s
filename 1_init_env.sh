#!/bin/bash

hostname=master105
register_addr="59.61.92.150:8888"

echo "============配置基本环境开始============"

yum -y install ntp ntpdate
ntpdate cn.pool.ntp.org
hwclock --systohc
echo "============同步时间done"

# 安装常用工具包
yum install -y yum-utils device-mapper-persistent-data lvm2 vim
yum makecache fast
echo "============常用工具包done"

# 设置hostname
hostnamectl set-hostname $hostname
echo "============set hostname done"

# 关闭防火墙
systemctl disable firewalld.service
systemctl stop firewalld.service
echo "============关闭防火墙done"

# 开启路由转发
echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/k8s.conf
sysctl -p /etc/sysctl.d/k8s.conf

iptables -P FORWARD ACCEPT
swapoff -a
echo "============路由转发&swap done"

# 配置hosts
cat >> /etc/hosts <<EOF
172.168.50.105 master105
172.168.50.106 node106
172.168.50.107 node107
172.168.50.108 node108
EOF
echo "============set hosts done"

# 设置阿里云docker yum仓库
cat > /etc/yum.repos.d/docker-ce.repo << EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF
echo "============set docker-ce.repo done"

# 设置阿里云k8s yum仓库
cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes] 
name=Kubernetes 
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64 
enabled=1 
gpgcheck=1 
repo_gpgcheck=1 
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg 
       http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
echo "============set kubernetes.repo done"


# 安装指定版本docker
yum install -y --setopt=obsoletes=0 docker-ce-17.12.1.ce-1.el7.centos
sed -i "s#.*ExecStart=/usr/bin/dockerd.*#ExecStart=/usr/bin/dockerd --insecure-registry $register_addr#gi" /usr/lib/systemd/system/docker.service
# 配置并启动docker服务
systemctl enable docker && systemctl start docker
docker --version
echo "============安装docker服务done"

echo "============配置基本环境完成============"
