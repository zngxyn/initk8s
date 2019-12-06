docker pull 59.61.92.150:8888/calico/kube-controllers:v3.1.4 
docker pull 59.61.92.150:8888/calico/cni:v3.1.4
docker pull 59.61.92.150:8888/calico/node:v3.1.4

docker tag 59.61.92.150:8888/calico/kube-controllers:v3.1.4 quay.io/calico/kube-controllers:v3.1.4
docker tag 59.61.92.150:8888/calico/cni:v3.1.4 quay.io/calico/cni:v3.1.4
docker tag 59.61.92.150:8888/calico/node:v3.1.4 quay.io/calico/node:v3.1.4
