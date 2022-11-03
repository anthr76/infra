FROM quay.io/coreos/butane@sha256:eb97659cc846cfd9a983ca2460f0509629e13a0e0598f04e19911c63bffa7686 as butane

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

