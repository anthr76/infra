#!/bin/bash

if [ "$HOSTNAME" == "toolbox" ]
then
  BUILDAH="host-spawn buildah"
  PODMAN="host-spawn podman"
else
  BUILDAH="BUILDAH"
  PODMAN="PODMAN"
fi

PLATFORM=linux/amd64,linux/arm64
$BUILDAH build --jobs=2 --platform=$PLATFORM --manifest fcos-k8s-node .
$BUILDAH tag localhost/fcos-k8s-node ghcr.io/anthr76/fcos-k8s-node:testing
$PODMAN manifest rm localhost/fcos-k8s-node
$PODMAN manifest push --all ghcr.io/anthr76/fcos-k8s-node:testing docker://ghcr.io/anthr76/fcos-k8s-node:testing
