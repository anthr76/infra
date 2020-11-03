# Typhoon <img align="right" src="https://storage.googleapis.com/poseidon/typhoon-logo.png">

Typhoon is a minimal and free Kubernetes distribution.

* Minimal, stable base Kubernetes distribution
* Declarative infrastructure and configuration
* Free (freedom and cost) and privacy-respecting
* Practical for labs, datacenters, and clouds

Typhoon distributes upstream Kubernetes, architectural conventions, and cluster addons, much like a GNU/Linux distribution provides the Linux kernel and userspace components.

---

## Steps to bootstrap <a href="https://www.cncf.io/certification/software-conformance/"><img align="right" src="https://storage.googleapis.com/poseidon/certified-kubernetes.png"></a>

TODO

---

## :computer:&nbsp; Hardware configuration

_All my Kubernetes master and worker nodes below are running bare metal forked [Typhoon](https://github.com/anthr76/typhoon/tree/master/bare-metal/flatcar-linux/kubernetes)_



| Device                  | Count | OS Disk Size | Data Disk Size      | Ram  | Purpose                                |
|-------------------------|-------|--------------|---------------------|------|----------------------------------------|
| HP ProBook 450 G1       | 1     | 256GB SSD    | 1TB SSD             | 16GB | k8s Worker                             |
| Raspberry Pi 4          | 3     | 256GB SSD    | N/A                 | 8 GB | k8s Master                             |
| Raspberry Pi 4          | 1     | 256GB SSD    | N/A                 | 8 GB | k8s Worker                             |