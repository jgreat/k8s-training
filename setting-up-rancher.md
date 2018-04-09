So lets get to it.

I have prepared few VMs and pre-pulled the required images ahead of time, just to speed things up. If you are interested in the gory details, check out the Git repo.

* 1 server
* 3 agents

### Start Rancher Server

The rancher server takes a few minuets to initialize so I've gone ahead and set up my rancher server ahead of time, but the command looks like this.

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