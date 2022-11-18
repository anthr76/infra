FROM quay.io/coreos/butane@sha256:346e9d38eb388baf40918737b9e2940c215085c3baa7c370d34a7ee066b8b544 as butane

ADD config.bu.yaml /config.bu.yaml

RUN \
  butane --pretty --strict config.bu.yaml > /config.ign

FROM quay.io/coreos-assembler/fcos:stable@sha256:4366918a490a34e161b115c0ff38fdaaf226841e1d3abaca8ed48571d05f4b43

COPY --from=butane /config.ign config.ign

ENV \
  K8S_VERSION=1.24

RUN \
  rpm-ostree ex module install cri-o:$K8S_VERSION/default && \
  /usr/libexec/ignition-apply config.ign && \
  rm -f config.ign && \
  ostree container commit

LABEL org.opencontainers.image.source https://github.com/anthr76/infra
