#!/usr/bin/env bash

export REPO_ROOT
REPO_ROOT=$(git rev-parse --show-toplevel)

need() {
    which "$1" &>/dev/null || die "Binary '$1' is missing but required"
}

need "kubectl"
need "envsubst"

if [ "$(uname)" == "Darwin" ]; then
  set -a
  . "${REPO_ROOT}/secrets/.secrets.env"
  set +a
else
  . "${REPO_ROOT}/secrets/.secrets.env"
fi

message() {
  echo -e "\n######################################################################"
  echo "# $1"
  echo "######################################################################"
}

kapply() {
  if output=$(envsubst < "$@"); then
    printf '%s' "$output" | kubectl apply -f -
  fi
}

CERT_MANAGER_READY=1
while [ $CERT_MANAGER_READY != 0 ]; do
  message "waiting for cert-manager to be fully ready..."
  kubectl -n cert-manager wait --for condition=Available deployment/cert-manager > /dev/null 2>&1
  CERT_MANAGER_READY="$?"
  sleep 5
done
kapply "$REPO_ROOT"/deployments/cert-manager/cloudflare/cert-manager-letsencrypt.txt