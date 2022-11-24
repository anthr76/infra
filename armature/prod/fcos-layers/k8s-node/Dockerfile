FROM quay.io/coreos/butane@sha256:346e9d38eb388baf40918737b9e2940c215085c3baa7c370d34a7ee066b8b544 as butane

ADD config.bu.yaml /config.bu.yaml

RUN \
  butane --pretty --strict config.bu.yaml > /config.ign

FROM quay.io/fedora/fedora-coreos:testing@sha256:86aafa567eebdbaa9cc2b4a43d3b5dccb5390b3a8bea1c38b5bbb9a09dfcec37

COPY --from=butane /config.ign config.ign

ENV \
  K8S_VERSION=1.24

RUN \
  rpm-ostree ex module install cri-o:$K8S_VERSION/default && \
  rpm-ostree install amd-gpu-firmware && \
  /usr/libexec/ignition-apply config.ign && \
  rm -f config.ign && \
  rpm-ostree cleanup -m && \
  # I'm a hack
  rm -rf /var/lib/dnf/ && \
  ostree container commit

LABEL org.opencontainers.image.source https://github.com/anthr76/infra
