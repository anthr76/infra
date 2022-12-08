PI4_UEFI_VERSION := "1.33"
FCOS_INSTALL_DISK := "/dev/sdX"
DEFAULT_INSTALL_BUTANE := "armature/prod/scr1/fcos/k8s-node/worker-config.bu.sops.yaml"

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

# Install FCOS for RPI4 to a disk with EFI.
burn-fcos-pi4:
    @echo foo
    #!/usr/bin/env bash
    set -euxo pipefail
    maybe needed not sure yet!?
    # if [[ "$HOSTNAME" == "toolbox" ]]; then
    #   PODMAN="host-spawn podman"
    # fi

    podman run --pull=always --privileged --rm \
    -q \
    -v /dev:/dev -v /run/udev:/run/udev -v .:/data -w /data \
    quay.io/coreos/coreos-installer:release \
    install {{ FCOS_INSTALL_DISK }} \
    -i $(sops -d {{ DEFAULT_INSTALL_BUTANE }} | podman run -q -i --rm --pull always quay.io/coreos/butane:release --strict)
