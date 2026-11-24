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
    just _flux-hr-sync

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
    just _flux-ks-sync

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
    just _flux-gr-sync

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

# Refresh expired client certs for civo-mgmt-0 (Civo k3s) and qgr1 (Kamaji TCP) in ~/.kube/config
kubeconfig-refresh civo_cluster="kutara" civo_region="nyc1" tcp_ns="tenant-cluster-qgr1" tcp="qgr1":
    #!/usr/bin/env bash
    set -euo pipefail
    kc="${KUBECONFIG:-$HOME/.kube/config}"
    work=$(mktemp -d); trap 'rm -rf "$work"' EXIT; chmod 700 "$work"
    cp "$kc" "$kc.bak-$(date +%Y%m%d%H%M%S)"
    ext() { kubectl --kubeconfig "$1" config view --raw -o jsonpath="{.$2}" | base64 -d > "$3"; }

    echo "==> civo-mgmt-0: fetching kubeconfig for {{ civo_cluster }} ({{ civo_region }})"
    civo kubernetes config "{{ civo_cluster }}" --region "{{ civo_region }}" > "$work/civo.conf"
    ext "$work/civo.conf" 'users[0].user.client-certificate-data' "$work/civo.crt"
    ext "$work/civo.conf" 'users[0].user.client-key-data' "$work/civo.key"
    ext "$work/civo.conf" 'clusters[0].cluster.certificate-authority-data' "$work/civo-ca.crt"
    kubectl --kubeconfig "$kc" config set-credentials civo-mgmt-0 --client-certificate="$work/civo.crt" --client-key="$work/civo.key" --embed-certs
    kubectl --kubeconfig "$kc" config set-cluster civo-mgmt-0 --certificate-authority="$work/civo-ca.crt" --embed-certs

    echo "==> qgr1: reading {{ tcp }}-admin-kubeconfig from Kamaji"
    kubectl --kubeconfig "$kc" --context civo-mgmt-0 -n "{{ tcp_ns }}" get secret "{{ tcp }}-admin-kubeconfig" \
      -o jsonpath='{.data.admin\.conf}' | base64 -d > "$work/qgr1.conf"
    ext "$work/qgr1.conf" 'users[0].user.client-certificate-data' "$work/qgr1.crt"
    ext "$work/qgr1.conf" 'users[0].user.client-key-data' "$work/qgr1.key"
    kubectl --kubeconfig "$kc" config set-credentials kubernetes-admin --client-certificate="$work/qgr1.crt" --client-key="$work/qgr1.key" --embed-certs

    for f in civo qgr1; do printf '%s cert ' "$f"; openssl x509 -noout -enddate -in "$work/$f.crt"; done
    kubectl --kubeconfig "$kc" --context civo-mgmt-0 get nodes >/dev/null && echo "civo-mgmt-0 OK"
    kubectl --kubeconfig "$kc" --context kubernetes-admin@qgr1 get nodes >/dev/null && echo "qgr1 OK"
