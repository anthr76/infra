# Typhoon <img align="right" src="https://storage.googleapis.com/poseidon/typhoon-logo.png">

### :warning: Note this cluster is currently **NOT** running typhoon due to lack of [NIC support on Raspberry Pi's](https://github.com/anthr76/infra/issues/9). In the interim this cluster is running Ubuntu 20.04.1 with [Kubespray](https://github.com/anthr76/infra/blob/643195b027d711027f5220a0d2e612e6524d0fa1/ansible/inventory/inventory.ini#L10). Docs will follow if this ends up being long term.

Typhoon is a minimal and free Kubernetes distribution.

* Minimal, stable base Kubernetes distribution
* Declarative infrastructure and configuration
* Free (freedom and cost) and privacy-respecting
* Practical for labs, datacenters, and clouds

Typhoon distributes upstream Kubernetes, architectural conventions, and cluster addons, much like a GNU/Linux distribution provides the Linux kernel and userspace components.

---

## Steps to bootstrap <a href="https://www.cncf.io/certification/software-conformance/"><img align="right" src="https://storage.googleapis.com/poseidon/certified-kubernetes.png"></a>

1. `calicoctl apply -f clusters/nwk1/intergrations/calico`
2. `./hack/bootstrap/bootstrap-cluster.sh`
3. `./hack/bootstrap/getkey.sh`
4. `./hack/bootstrap/generate_objects.sh`

---

## :computer:&nbsp; Hardware configuration

_All my Kubernetes master and worker nodes below are running bare metal forked [Typhoon](https://github.com/anthr76/typhoon/tree/master/bare-metal/flatcar-linux/kubernetes)_



| Device                  | Count | OS Disk Size | Data Disk Size      | Ram  | Purpose                                |
|-------------------------|-------|--------------|---------------------|------|----------------------------------------|
| HP ProBook 450 G1       | 1     | 256GB SSD    | 1TB SSD             | 16GB | k8s Worker                             |
| Raspberry Pi 4          | 3     | 256GB SSD    | N/A                 | 4 GB | k8s Master                             |
| Raspberry Pi 4          | 1     | 256GB SSD    | N/A                 | 4 GB | k8s Worker                             |