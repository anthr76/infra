FROM quay.io/coreos-assembler/fcos:stable@sha256:de2dbf690f82077d1eae67da30e2a918908dcd457b518ae1de8671192309aba8

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

