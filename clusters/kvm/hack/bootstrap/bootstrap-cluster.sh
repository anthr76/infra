#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

need() {
    which "$1" &>/dev/null || die "Binary '$1' is missing but required"
}

need "kubectl"
need "helm"

message() {
  echo -e "\n######################################################################"
  echo "# $1"
  echo "######################################################################"
}

installFlux() {
  message "installing flux"
  # install flux
  kubectl create ns flux
  helm repo add fluxcd https://charts.fluxcd.io
  helm upgrade --install flux --values "$REPO_ROOT"/clusters/kvm/gitops/flux/flux/flux-values.yaml --namespace flux fluxcd/flux
  helm upgrade --install helm-operator --values "$REPO_ROOT"/clusters/kvm/gitops/flux/helm-operator/helm-operator-values.yaml --namespace flux fluxcd/helm-operator

  FLUX_READY=1
  while [ $FLUX_READY != 0 ]; do
    echo "waiting for flux pod to be fully ready..."
    kubectl -n flux wait --for condition=available deployment/flux
    FLUX_READY="$?"
    sleep 5
  done

  # grab output the key
  FLUX_KEY=$(kubectl -n flux logs deployment/flux | grep identity.pub | cut -d '"' -f2)

  message "adding the key to github automatically"
  "$REPO_ROOT"/clusters/kvm/hack/bootstrap/add-repo-key.sh "$FLUX_KEY"
}

installFlux

message "all done!"
kubectl get nodes -o=wide
