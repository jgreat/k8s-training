#!/bin/bash

docker pull rancher/agent:v1.2.9
docker pull rancher/k8s:v1.8.5-rancher4
docker pull rancher/scheduler:v0.8.3
docker pull rancher/net:v0.13.7
docker pull rancher/network-manager:v0.7.19
docker pull gcr.io/google_containers/kubernetes-dashboard-amd64:v1.8.0
docker pull rancher/lb-service-rancher:v0.7.17
docker pull rancher/metadata:v0.9.5
docker pull rancher/kubectld:v0.8.5
docker pull gcr.io/google_containers/k8s-dns-sidecar-amd64:1.14.5
docker pull gcr.io/google_containers/k8s-dns-kube-dns-amd64:1.14.5
docker pull gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.5
docker pull rancher/kubernetes-agent:v0.6.6
docker pull gcr.io/google_containers/heapster-influxdb-amd64:v1.3.3
docker pull gcr.io/google_containers/heapster-grafana-amd64:v4.4.3
docker pull gcr.io/kubernetes-helm/tiller:v2.6.1
docker pull rancher/dns:v0.15.3
docker pull rancher/kubernetes-auth:v0.0.8
docker pull rancher/healthcheck:v0.3.3
docker pull rancher/etcd:v2.3.7-13
docker pull rancher/etc-host-updater:v0.0.3
docker pull gcr.io/google_containers/heapster-amd64:v1.4.0
docker pull rancher/net:holder
docker pull gcr.io/google_containers/pause-amd64:3.0
