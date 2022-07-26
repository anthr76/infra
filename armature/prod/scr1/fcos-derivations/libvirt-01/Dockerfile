FROM quay.io/coreos-assembler/fcos:stable@sha256:73d4779bcaa16d5edcd2504670a4fe08177b2519002258bcf0a1ca812787dfac

COPY *.nmconnection /etc/NetworkManager/system-connections

RUN \
  rpm-ostree install \
    libvirt-daemon-config-network \
    libvirt-daemon-kvm \
    qemu-kvm \
    virt-install && \
  mkdir -p /var/roothome/.ssh/authorized_keys.d && \
  curl https://github.com/anthr76.keys > /var/roothome/.ssh/authorized_keys.d/github_anthr76 && \
  rpm-ostree cleanup -m && \
  ostree container commit

