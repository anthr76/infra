# Getting Started

!!! note "Work in progress"
    This document is a work in progress.

## Tools needed to operate this repository

> This is a brief overview of some of the tools that are required to interface with this repo's GitOps, IaC, or Ansible.

### Fedora

1. Add preliminary repositories.

> I maintain a [OBS](https://build.opensuse.org/project/show/home:anthr76:kubernetes) repo for various tooling and GoLang apps that are distributed on Linux as a static binary. We'll add Google's upstream RPM repo for Kubectl though it needs to be added as a file.

```sh
# dnf config-manager --add-repo https://download.opensuse.org/repositories/home:anthr76:kubernetes/Fedora_33/home:anthr76:kubernetes.repo

# dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo

# cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
```

2. Install tools

```sh
# dnf install -y pre-commit kubectl git-crypt ansible dnf-plugins-core terraform python3-devel flux
```

### General

1. Unlock the repo with your GPG key

```sh
$ git-crypt unlock
```

1. Install pre-commit hooks

```sh
$ pre-commit install
```

#### Navigating the file structure

Viewing the repository from a top down view.

```
ansible/
clusters/
├─ cluster1/
│  ├─ gotk/
│  ├─ IaC/
├─ cluster2/
│  ├─ gotk/
│  ├─ IaC/
docs/
gitops/
├─ core/
│  ├─ base/
│  ├─ overlays/
│  │  ├─ cluster1/
│  │  ├─ cluster2/
├─ namespaces/
│  ├─ base/
│  ├─ overlays/
│  │  ├─ cluster1/
│  │  ├─ cluster2/
```

This is a simplified view of the directory layout on how everything works. A simple explanation would look like

```
ansible/
clusters/
├─ cluster1/
│  ├─ gotk/ <- Flux's repo definition to begin it's gotk-sync
│  ├─ IaC/  <- Any pertinent directories or files required for cluster creation.
├─ cluster2/
│  ├─ gotk/ <- Flux's repo definition to begin it's gotk-sync
│  ├─ IaC/  <- Any pertinent directories or files required for cluster creation.
docs/
gitops/
├─ core/
│  ├─ base/ <- Let flux unconditionally apply things in here with no modifications regardless to the cluster.
│  ├─ overlays/
│  │  ├─ cluster1/ <- Apply Kustomize overlays from base on cluster 1
│  │  ├─ cluster2/ <- Apply Kustomize overlays from base on cluster 2
├─ namespaces/
│  ├─ base/ <- Let flux unconditionally apply things in here with no modifications regardless to the cluster.
│  ├─ overlays/
│  │  ├─ cluster1/ <- Apply Kustomize overlays from base on cluster 1
│  │  ├─ cluster2/ <- Apply Kustomize overlays from base on cluster 2
```

More information about Kustomize, and flux is out scope of getting started with this repo but this should get you antiquated enough to understand better the directory layout.
