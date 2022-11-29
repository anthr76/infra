FROM quay.io/coreos/butane@sha256:346e9d38eb388baf40918737b9e2940c215085c3baa7c370d34a7ee066b8b544 as butane

ADD config.bu.yaml /config.bu.yaml

RUN \
  butane --pretty --strict config.bu.yaml > /config.ign

FROM quay.io/fedora/fedora-coreos:testing@sha256:d83dff6f06f08baa2f036c209f083660ec8da1ec6822449bd1b6db5eab8067ab

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
