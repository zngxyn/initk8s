#!/bin/bash
register_addr="59.61.92.150:8888"

chmod -R +x *
mkdir -p /data/ent/docker/repo/registry /data/ent/kubernetes
cp docker-ce.repo /etc/yum.repos.d
cp kubernetes.repo /etc/yum.repos.d
cp registry/config.yml /data/ent/docker/repo
yum install -y yum-utils device-mapper-persistent-data lvm2
#yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum makecache fast
yum install -y --setopt=obsoletes=0 docker-ce-17.12.1.ce-1.el7.centos
sed -i 's@.*ExecStart=/usr/bin/dockerd.*@ExecStart=/usr/bin/dockerd --insecure-registry '$register_addr'@gi' /usr/lib/systemd/system/docker.service
systemctl enable docker && systemctl start docker
systemctl disable firewalld.service
systemctl stop firewalld.service
#docker run -d -p 5000:5000 -v /data/ent/docker/repo/registry:/var/lib/registry  -v /data/ent/docker/repo/config.yml:/etc/docker/registry/config.yml  registry
docker run -d -v /opt/registry:/var/lib/registry -p 5000:5000 --restart=always registry:2.5.0
sed -i 's@.*register_addr=.*@register_addr="'$register_addr'\"@gi' registry/init_register_images.sh
bash registry/init_register_images.sh
