# Minikube

## Install

https://github.com/kubernetes/minikube

## Start

Start up minikube.  Give it a bit more memory and add an ingress controller

```shell
minikube start --bootstrapper kubeadm --kubernetes-version v1.8.10 --memory 4096
minikube addons enable ingress
```