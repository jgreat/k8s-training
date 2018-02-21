# k8s-training

## Topics

* Setting up Rancher
* Deploying Kubernetes
* Setting up `kubectl`
* Pods
* Deployments
* Services
* Config maps
* Ingresses

## Setting up Rancher

I have prepared 4 VMs ahead of time.

* 1 server
* 3 agents

Rancher's documentation has some recommendations around sizing, but the only real requirement is a fairly modern version of Linux and a compatible version of Docker.

> **Note**: The Terraform templates I used to create the server and agent nodes are included in the `./infrastructure` directory.
>
> To speed things up, I pre-pulled the necessary images for this demo.  See `./infrastructure/agent_images.sh` for details.

### Start Rancher Server

Our stable release of Rancher Server has everything built in to get you started as easily as possible.  When you're ready to put Rancher in production, check out 

``` bash
docker run -d -p 8080 rancher/server:stable
```

> **Note**: Rancher server runs its http service on port 8080.  My setup also includes a simple HAproxy container listening on ports 80 and 443 that integrates with LetsEncrypt to generate valid ssl certificates.
>
>See `./infrastructure/tf-digitalocean/server-cloud-config.yml` for more information.

### Set up Access Control

We highly recommend that you set up access control.

`Admin -> Access Control`

We integrate with various authentication systems like ActiveDirectory, Github, LDAP, but for this demo we will use local rancher Database as our source.

### Create Rancher Environment

`Environments -> Manage Environments`

* Give it a name
* Select Template type Kubernetes
* Give additional users or groups access as required.

### Add Rancher Agent Hosts

Host requirements are very simple. Since everything is just containers all we need is a modern version of linux and a compatible version of docker. Just start the agent container and we'll take it from there.

`Add Host`

There are 2 ways to add agent hosts:

#### Cloud Provider

We provide you the ability to launch VMs in the your Cloud Provider of choice.

Just select one of the available providers, enter in your credentials and fill out some details about where you want to launch the VMs.

In about 10 minutes you'll have a fully functional Rancher environment.

#### Custom

Since no one wants to stare at my screen for 10 minuets, today we will use the Custom method to start up our agents.

Using the custom command is as simple as copying and pasting this `docker run` command on the VMs you want to add to this Rancher Environment.

Each environment gets a unique registration url so you can just include this command as a step in your VM orchestration tool of choice. Terraform, puppet, chef, just plain cloud-init... whatever.

#### Kubernetes

About Rancher Kubernetes

* 100% upstream Kubernetes
* [Cloud Native Computing Foundation Certified](https://www.cncf.io/certification/software-conformance/)
* If it works in kubernetes, it will work here.
* We don't believe in vendor lock in, If you decide "you want to take your ball and go home", your workloads will be portable to any other standard kubernetes provider.

So why would you use Rancher?

* One click upgrade to new Kubernetes versions.
* We maintain the services and relaunch incase of node failure
* 24 hours a day 7 a week
* Redundant `etcd` with backups every 15 minutes and 24 hour retention
* Centralized authentication with your choice of provider, AD, Github, LDAP

Kubernetes is just the start, we also provide some extras

* Kubernetes dashboard
* Tiller for helm catalogs
* Basic Monitoring with heapster and Grafana
* Convenient Shell access for running `kubectl`

## Setting up `kubectl`

`Kubernetes -> CLI -> Generate Config`

Copy this config into `~/.kube/config`

> **Note:** If you have a lot of Kubernetes contexts use a shell that will help keep track of which context you are in.
>
> I'm using ZSH with oh-my-zsh framework with the Spaceship theme

## Lets run something

Lets just jump in and get something running.

`kubectl` has a helper command called `run`

`kubectl run` will create some of the lower level objects and abstractions required to get workloads running.

``` shell
kubectl run game --image=jgreat/2048:0.0.1 --port=80 --replicas 3
```

## So what did this do?

This created a 3 types of objects.  First it created a Deployment, which created a replicaSet, which created a number of pods equal to the number of replicas we defined.

## Pods

* Smallest unit that can be deployed in Kubernetes
* Consist of one or more containers that are scheduled together on the same node.
* Each pod is given a unique IP address.
  * This means that all the containers in a pod share that IP address.
  * The workloads in different containers in a pod can talk to each other via localhost

If this is confusing, don't worry about it too much. For the sake of this demo all of our pods will only have one container, so just think of a pod as a container.

Show all the pods

``` shell
kubectl get pod
```

Show details of a pod

``` shell
kubectl describe pod game-...
```

Get a shell

``` shell
kubectl exec -it game-... sh
```

Show Logs

``` shell
kubectl logs -f game-...
```

## ReplicaSet

A replicaSet is an object used to manage the lifecycle and scale (replicas) of a pod.

``` shell
kubectl get replicaset game-...
```

Instead of **imperatively** describing "I want game-pod-1 and game-pod-2 and game-pod-3" a replicaSet allows me to **declare** I want game-pods, make sure there are 3 running at all times.

> **Note** There are several other objects that also schedule pods, but in different ways. daemonSets, scaleSets and jobs are some examples but those are beyond the scope of this training.

In recent versions of Kubernetes you actually don't interact directly with replicaSets, you create deployments.

## Deployments

So what `run` really does is create a deployment.

The purpose of the Deployment object is to manage the release of new versions of your applications. Kubernetes tracks the history of deployments and allows you the ability to undo a "rollout"

``` shell
kubectl get deployment game
```

## Manifests

So far I've just shown you creating resources with some one off commands, but the real strength of Kubernetes is that you can create resources in a Declarative format.  You do this by creating and applying manifests.

 Every object in Kubernetes can be described with a yaml document. This is a manifest.

``` shell
kubectl get deployment game -o yaml
```

### Create a manifest

Lets delete the existing deployment, by default this will cleanup all of its child resources.

```
kubectl delete deployment game
```

Since what we actually did was create a deployment, lets go ahead and create a manifest for that deployment.  The easiest way to get started with this is to use the same `run` command we used to create our initial deployment but add the `--dry-run` and the `-o yaml` options. We will redirect the output to a file.

``` shell
kubectl run game --image=jgreat/2048:0.0.1 --port=80 --replicas 3 --record --dry-run -o yaml > game-deployment.yml
```

### Apply a manifest

Lets create that deployment with our new yml file.

``` shell
kubectl apply -f game-deployment.yml
```

### Edit a manifest

Lets edit this deployment

``` shell
vi game-deployment.yml
```

### Update Deployment

Lets apply the updated manifest.

Change the image value and update the change-cause annotation

``` shell
kubectl apply -f game-deployment.yml
```

### Show history

``` shell
kubectl rollout history deployment game
```

### Rollback new version

``` shell
kubectl rollout undo deployment/game
```

## Services

``` shell
vi game-service.yml
```

``` shell
kubectl apply -f game-service.yml
```

Shell into service
show new service dns `game.default.svc.cluster.local`

## Ingress

``` shell
kubectl apply -f game-ingress.yml
```

show ingress
``` shell
kubectl get ingress game -o wide
```

Browse to game.jgreat.me
