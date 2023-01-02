FCOS_INSTALL_DISK := "/dev/sdXXXX"
DEFAULT_INSTALL_BUTANE := "armature/prod/scr1/fcos/k8s-node/worker-config.bu.sops.yaml"
PODMAN := "podman"
TMPDIR := `mktemp -d`

_default:
    @just --list

# Reconcile all GitRepositories and Kustomizations on selected context
flux-reconcile:
    #!/usr/bin/env bash
    set -euxo pipefail
    for GR in $(kubectl get gitrepositories.source.toolkit.fluxcd.io -A -o json | jq -r '.items[] | [.metadata.name, .metadata.namespace] | @csv'); do
      resource=$(echo $GR | awk -F',' '{print $1}'| tr -d '"')
      ns=$(echo $GR | awk -F',' '{print $2}'| tr -d '"' )
      kubectl annotate -n "$ns" --field-manager=flux-client-side-apply --overwrite \
      gitrepositories.source.toolkit.fluxcd.io "$resource" reconcile.fluxcd.io/requestedAt="$(date +%s)"
    done

    for KS in $(kubectl get ks -A -o json | jq -r '.items[] | [.metadata.name, .metadata.namespace] | @csv'); do
      resource=$(echo $KS | awk -F',' '{print $1}'| tr -d '"')
      ns=$(echo $KS | awk -F',' '{print $2}'| tr -d '"' )
      kubectl annotate -n "$ns" --field-manager=flux-client-side-apply --overwrite \
      kustomization/"$resource" reconcile.fluxcd.io/requestedAt="$(date +%s)"
    done

_uboot:
    {{ PODMAN }} run --privileged --rm \
    --security-opt label=disable \
    -q -it \
    -e FCOSDISK={{FCOS_INSTALL_DISK}} \
    -v /dev:/dev -v /run/udev:/run/udev -v $PWD/.just/uboot.sh:/uboot.sh \
    registry.fedoraproject.org/fedora:37 \
    /uboot.sh

# Install FCOS for RPI4 to a disk with EFI.
burn-fcos-pi4:
    # Transpile sops'd butane to ignition
    sops -d {{ DEFAULT_INSTALL_BUTANE }} > {{TMPDIR}}/config.bu
    podman run --rm \
    --security-opt label=disable \
    -w /work \
    -v {{TMPDIR}}:/work quay.io/coreos/butane:release \
    --pretty --strict /work/config.bu -o /work/config.ign
    # Install FCOS to a disk.
    # Needs sudo but this is destructive so override $PODMAN
    {{ PODMAN }} run --pull=always --privileged --rm \
    -q \
    -v /dev:/dev -v /run/udev:/run/udev -v {{TMPDIR}}/config.ign:{{TMPDIR}}/config.ign \
    quay.io/coreos/coreos-installer:release \
    install \
    --architecture=aarch64 \
    -i {{TMPDIR}}/config.ign \
    {{ FCOS_INSTALL_DISK }}
    just PODMAN="{{PODMAN}}" FCOS_INSTALL_DISK={{FCOS_INSTALL_DISK}} TMPDIR={{TMPDIR}} _uboot
