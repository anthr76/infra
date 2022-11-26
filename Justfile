build-push-k8s-node:
  ./armature/prod/fcos-layers/k8s-node/build-push.sh

flux-reconcile:
  #!/bin/bash
  kubectl get kustomization -n flux-system --template '{{range .items}}{{printf "%s\\n" .metadata.name}}{{end}}' \
  | sort -n | xargs -P 50 -I '{}' kubectl annotate -n flux-system --field-manager=flux-client-side-apply --overwrite \
  kustomization/'{}' reconcile.fluxcd.io/requestedAt="$(date +%s)"


