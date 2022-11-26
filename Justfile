
build-push-k8s-node:
  ./armature/prod/fcos-layers/k8s-node/build-push.sh

flux-reconcile:
  #!/usr/bin/env bash

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

