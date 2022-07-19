FROM quay.io/coreos-assembler/fcos:stable@sha256:6dd3510f4e5f5306c18a5c70030f197a10afde18f51d70ed11ae977e13046dee

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

