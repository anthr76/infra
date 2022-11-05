FROM quay.io/coreos/butane@sha256:1d5d661f23df28833db296244023e8b32d9490442e4149327ba9846abe64329f as butane

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

