# infra

Welcome to the docs on my homelab infrastructure. This includes Ansible Automation, Infrastructure as code, and GitOps model for Kubernetes.

## Story

Two years ago I had an itch to get started with my homelab. Docker was getting a ton of positive press, and it seemed like the best avenue to take in a home lab and you can everything contained in a container! So after learning Docker and a bit more with Linux I settled on a docker-compose setup. This has served me very well for a few years but as time went on I began to see the weak points, such as single points of failure. Docker-Swarm didn't compel me much as I knew Docker was in a bad state being bought out and Kubernetes was the mantra for multi-host container orchestration. After discovering the amazing k8s-at-home community I decided it was time to take a deep-dive into K8s and finally learn how to roll my homelab with Kubernetes.

### K8s/K3s/K0s/Rancher

[k3s](https://k3s.io/) comes with a very low barrier to entry in getting a Kubernetes cluster running. After deploying it with [k3sup](https://github.com/alexellis/k3sup) I fell in love with the simplicity and love the single binary approach. With k3sup the time it took from getting a Kubernetes cluster up and running was literally minutes. Without much Kubernetes knowledge this allowed me to teardown the cluster and install it again, each time learning new things like how to deploy applications with [Helm](https://helm.sh/), set up a load balancer using [Metallb](https://metallb.universe.tf/), how to handle ingress and storage.

During my testing & learning phase I went through several [k3s](https://k3s.io/), K8s, and Rancher deployments to help me decide what I wanted to move forward with. I love the idea of learning while gaining self-healing in your home infrastructure while at the same time not having to tend to it constantly.This is what finally had me decide on vanilla Kubernetes.

### Flux

After awhile of tinkering with k3s, I started reading up on GitOps principles and fell in love with the idea of having a Git repository drive a Kubernetes cluster state. No more missing configuration files, backing up compose files in fear of losing them. I could have mostly everything Kubernetes cares about tracked in a Git repo, while having an operator running in my cluster reading from my Git repo.

This is where [Flux](https://toolkit.fluxcd.io/) comes into play. Flux is an awesome tool that syncs my Git repo with my cluster. Any change I make in my Git repo will be directly applied by Flux in my Kubernetes cluster.

### Renovate

So I have my cluster running, I have Flux running inside and it is synced to my Git repository. How do I handle application updates? Flux has this built into their application using the [image-automation-controller](https://toolkit.fluxcd.io/components/image/controller/) but I am not a fan of having applications auto-update. Sometimes I want to read application changelogs or review source code before I commit to upgrading.

I decided that [Renovate](https://www.whitesourcesoftware.com/free-developer-tools/renovate) would be a good solution to my problem. Renovate works by scanning my Git repository and offering changes in the form of a pull request when a new container image update or helm chart update is found.

### Conclusion

Overall I am very happy being off my Portainer/Docker Swarm cluster and finally using Kubernetes. The road was rocky but with passion and perseverance I was able to reach my goal.

It should go without saying a lot of what is built upon here is not only my ideas. A lot of work is being done by other people in the k8s@home community.
