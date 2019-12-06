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
