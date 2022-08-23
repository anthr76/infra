FROM quay.io/coreos-assembler/fcos:stable@sha256:83971b0aec1f5f4ab8fba57d8b6c3388f65bdf660c2750b8b7a4745a71e330c1

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

