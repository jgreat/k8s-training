# Using Docker-For-*

## Install Docker-For-*

### Windows
I like the chocolatey package manager: https://chocolatey.org/

```powershell
choco install docker-for-windows
```

### Mac

https://docs.docker.com/docker-for-mac/install/

## Turn on the edge channel

Opens Settings -> General Tab
Small print at the bottom switch to Edge verson.

Kubernetes Tab -> Enable Kubernetes

More info: https://blog.docker.com/2018/01/docker-windows-desktop-now-kubernetes/

## Install kubectl

kubectl is the main cli interface for k8s

### Windows

```powershell
choco install kubernetes-cli
```

### Mac

```shell
brew install kubectl
```

## Install helm

Helm is a tool to launch prebuilt catalogs into k8s.

### Windows

```powershell
choco install kubernetes-helm
```

### Mac

```shell
brew install kubernetes-helm
```

## Add Ingress Controller

Docker-for-* doesn't come with a configured ingress controller.  Use `helm` to launch one.

```powershell
helm init
helm install stable/nginx-ingress --name ingress-nginx --namespace ingress-nginx
```