# Kubic <img align="right" src="https://raw.githubusercontent.com/kubic-project/kubic-o-o/master/assets/images/logo.svg">

Multi-purpose Standalone & Kubernetes Container Operating System based on openSUSE MicroOS

---

## Steps to bootstrap <a href="https://www.cncf.io/certification/software-conformance/"><img align="right" src="https://storage.googleapis.com/poseidon/certified-kubernetes.png"></a>

*To Be Revised*
~~~1. `calicoctl apply -f clusters/nwk1/intergrations/calico`~~~
~~~2. `./hack/bootstrap/bootstrap-cluster.sh`~~~
~~~3. `./hack/bootstrap/getkey.sh`~~~
~~~4. `./hack/bootstrap/generate_objects.sh`~~~



---

## :computer:&nbsp; Hardware configuration

_All my Kubernetes master and worker nodes below are running bare metal forked [Typhoon](https://github.com/anthr76/typhoon/tree/master/bare-metal/flatcar-linux/kubernetes)_



| Device                  | Count | OS Disk Size | Data Disk Size      | Ram  | Purpose                                |
|-------------------------|-------|--------------|---------------------|------|----------------------------------------|
| HP ProBook 450 G1       | 1     | 256GB SSD    | 1TB SSD             | 16GB | k8s Worker                             |
| Raspberry Pi 4          | 2     | 256GB SSD    | N/A                 | 4 GB | k8s Master                             |
| Raspberry Pi 4          | 1     | 256GB SSD    | N/A                 | 8 GB | k8s Master                             |
| Raspberry Pi 4          | 1     | 256GB SSD    | N/A                 | 4 GB | k8s Worker                             |
