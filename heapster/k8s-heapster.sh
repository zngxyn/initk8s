docker pull 59.61.92.150:8888/heapster-influxdb-amd64:v1.3.3
docker pull 59.61.92.150:8888/heapster-grafana-amd64:v4.4.3
docker pull 59.61.92.150:8888/heapster-amd64:v1.4.2

docker tag 59.61.92.150:8888/heapster-influxdb-amd64:v1.3.3 k8s.gcr.io/heapster-influxdb-amd64:v1.3.3
docker tag 59.61.92.150:8888/heapster-grafana-amd64:v4.4.3 k8s.gcr.io/heapster-grafana-amd64:v4.4.3
docker tag 59.61.92.150:8888/heapster-amd64:v1.4.2 k8s.gcr.io/heapster-amd64:v1.4.2
