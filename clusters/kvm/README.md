# Typhoon <img align="right" src="https://storage.googleapis.com/poseidon/typhoon-logo.png">

Typhoon is a minimal and free Kubernetes distribution.

* Minimal, stable base Kubernetes distribution
* Declarative infrastructure and configuration
* Free (freedom and cost) and privacy-respecting
* Practical for labs, datacenters, and clouds

Typhoon distributes upstream Kubernetes, architectural conventions, and cluster addons, much like a GNU/Linux distribution provides the Linux kernel and userspace components.

---

## Steps to bootstrap <a href="https://www.cncf.io/certification/software-conformance/"><img align="right" src="https://storage.googleapis.com/poseidon/certified-kubernetes.png"></a>

1. `./hack/bootstrap/bootstrap-cluster.sh`
2. `./hack/bootstrap/getkey.sh`
3. `./hack/bootstrap/generate_objects.sh`

---

## :computer:&nbsp; Hardware configuration

_All my Kubernetes master and worker nodes below are running bare metal forked [Typhoon](https://github.com/anthr76/typhoon/tree/master/bare-metal/flatcar-linux/kubernetes)_



| Device                  | Count | OS Disk Size | Data Disk Size      | Ram  | Purpose                                |
|-------------------------|-------|--------------|---------------------|------|----------------------------------------|
| Virtual Machine/kvm     | 1     | 10GB Qcow    | 10GB Qcow           | 4GB  | k8s Master                             |
| Virtual Machine/kvm     | 3     | 10GB Qcow    | 10GB Qcow           | 4GB  | k8s Worker                             |
