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

# Sync Flux GitRepositories
_flux-gr-sync:
    kubectl get gitrepositories --all-namespaces --no-headers | awk '{print $1, $2}' \
      | xargs --max-procs=4 -l bash -c \
        'kubectl -n $0 annotate gitrepository/$1 reconcile.fluxcd.io/requestedAt=$(date +%s) --field-manager=flux-client-side-apply --overwrite'

# Sync Flux Kustomizations
_flux-ks-sync:
    kubectl get kustomization --all-namespaces --no-headers | awk '{print $1, $2}' \
      | xargs --max-procs=4 -l bash -c \
        'kubectl -n $0 annotate kustomization/$1 reconcile.fluxcd.io/requestedAt="$(date +%s)" --field-manager=flux-client-side-apply --overwrite'

# Sync Flux HelmReleases
_flux-hr-sync:
    kubectl get helmreleases --all-namespaces --no-headers | awk '{print $1, $2}' \
      | xargs --max-procs=4 -l bash -c \
        'kubectl -n $0 annotate helmrelease/$1 reconcile.fluxcd.io/requestedAt="$(date +%s)" --overwrite'

# Sync Flux GitRepos,Kustomizations, and HRs
flux-sync:
    just _flux-gr-sync
    just _flux-ks-sync
    just _flux-hr-sync

# Suspend Flux HelmReleases
_flux-hr-suspend:
    kubectl get helmreleases --all-namespaces --no-headers | awk '{print $1, $2}' \
      | xargs --max-procs=4 -l bash -c \
        'kubectl -n $0 patch helmrelease/$1 --type merge --patch "{\"spec\":{\"suspend\":true}}"'

# Resume Flux HelmReleases, and reconcile them like a flux resume hr would
_flux-hr-resume:
    kubectl get helmreleases --all-namespaces --no-headers | awk '{print $1, $2}' \
      | xargs --max-procs=4 -l bash -c \
        'kubectl -n $0 patch helmrelease/$1 --type merge --patch "{\"spec\":{\"suspend\":false}}"'
    just flux-hr-sync

# Suspend Flux Kustomizations
_flux-ks-suspend:
    kubectl get kustomization --all-namespaces --no-headers | awk '{print $1, $2}' \
      | xargs --max-procs=4 -l bash -c \
        'kubectl -n $0 patch kustomization/$1 --type merge --patch "{\"spec\":{\"suspend\":true}}"'

# Resume Flux Kustomizations, and reconcile them like a flux resume ks would
_flux-ks-resume:
    kubectl get kustomization --all-namespaces --no-headers | awk '{print $1, $2}' \
      | xargs --max-procs=4 -l bash -c \
        'kubectl -n $0 patch kustomization/$1 --type merge --patch "{\"spec\":{\"suspend\":false}}"'
    just flux-ks-sync

# Suspend Flux GitRepo
_flux-gr-suspend:
    kubectl get gitrepo --all-namespaces --no-headers | awk '{print $1, $2}' \
      | xargs --max-procs=4 -l bash -c \
        'kubectl -n $0 patch gitrepo/$1 --type merge --patch "{\"spec\":{\"suspend\":true}}"'

# Resume Flux GitRepo, and reconcile them like a flux resume source git would
_flux-gr-resume:
    kubectl get gitrepo --all-namespaces --no-headers | awk '{print $1, $2}' \
      | xargs --max-procs=4 -l bash -c \
        'kubectl -n $0 patch gitrepo/$1 --type merge --patch "{\"spec\":{\"suspend\":false}}"'
    just flux-gr-sync

# Do a flux-*-suspend of all resources tracked in Just
flux-suspend:
    just _flux-gr-suspend
    just _flux-ks-suspend
    just _flux-hr-suspend

# Do a flux-*-resume of all resources tracked in Just
flux-resume:
    just _flux-gr-resume
    just _flux-ks-resume
    just _flux-hr-resume
