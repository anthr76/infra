#!/bin/sh
set -e
echo "Terraforming..."
terraform apply

echo "Fetching kubeconfig from master..."
scp localanthony@["$(first_master_nodes_private)"]:.kube/config ~/.kube/config || (echo "Master node didn't come up yet. Try again in a bit" && exit 1)
