FROM quay.io/coreos-assembler/fcos:stable@sha256:b6d4e67f3e96e1b966fc2d9d59b96bdb75ea03de5e11d16b9c18bd67583a688b

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

