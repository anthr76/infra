FROM quay.io/coreos/butane@sha256:26299edd10ae149e432a25226b6e8195f47e96f21b4c7ce6effe8a8aa856664b as butane

ADD config.bu.yaml /config.bu.yaml

RUN \
  butane --pretty --strict config.bu.yaml > /config.ign

FROM quay.io/fedora/fedora-coreos:testing

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
