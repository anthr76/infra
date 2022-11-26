
build-push-k8s-node:
  ./armature/prod/fcos-layers/k8s-node/build-push.sh

flux-reconcile:
  #!/usr/bin/env bash
  for KS in $(kubectl get ks -n flux-system -o json | jq -r .items[].metadata.name); do
    kubectl annotate -n flux-system --field-manager=flux-client-side-apply --overwrite \
    kustomization/$KS reconcile.fluxcd.io/requestedAt="$(date +%s)"
  done

