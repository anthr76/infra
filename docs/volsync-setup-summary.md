# VolSync Setup Summary

This document provides a quick summary of the VolSync setup for the SCR1 cluster with rsync.net backing storage.

## What Was Configured

### Infrastructure Components

1. **Helm Repository**: `k8s/base/flux-system/helm-chart-repositories/backube-charts.yaml`
   - Provides access to the Backube VolSync Helm chart

2. **VolSync Operator**: `k8s/base/volsync-system/`
   - Namespace: `volsync-system`
   - Deployed via Helm with security hardening
   - Uses existing cluster infrastructure patterns

3. **SSH Key Management**: `k8s/base/volsync-system/secrets/`
   - ExternalSecret retrieves keys from Google Secret Manager
   - Uses existing `gcp-kutara-prod` ClusterSecretStore
   - Three keys required: private key, public key, and host key

4. **Flux Integration**: Added to `k8s/clusters/scr1-cluster-0/definitions/infra.yaml`
   - VolSync deployed via GitOps
   - Follows existing cluster deployment patterns

### Key Files Created/Modified

```text
k8s/base/flux-system/helm-chart-repositories/backube-charts.yaml    # NEW
k8s/base/volsync-system/                                            # NEW DIRECTORY
├── secrets/
│   ├── kustomization.yaml
│   └── rsync-net-ssh-keys.yaml
├── helm-release.yaml
├── kustomization.yaml
└── namespace.yaml
k8s/clusters/scr1-cluster-0/definitions/volsync-system.yaml         # NEW
docs/volsync.md                                                     # NEW
docs/volsync-examples.md                                            # NEW
docs/volsync-setup-summary.md                                       # NEW
devenv.nix                                                          # UPDATED - Added infrastructure tools
```

## Next Steps

### 0. Set Up Development Environment

```bash
# Enter the development environment with all required tools
devenv shell

# This will install and make available:
# - terraform, kubectl, helm, flux, sops, just
# - gcloud CLI, SSH tools, and other dependencies
```

### 1. Set Up rsync.net Account

- Create account at rsync.net
- Note your account details (e.g., `zh1234.rsync.net`)

### 2. Generate and Configure SSH Keys

- Generate SSH key pair with: `ssh-keygen -t ed25519 -f ~/.ssh/volsync-rsync-net -C "volsync@scr1-cluster"`
- Add public key to rsync.net authorized_keys
- Get host key with: `ssh-keyscan your-account.rsync.net`

### 3. Store Keys in Google Secret Manager

```bash
gcloud secrets create rsync-net-private-key --data-file ~/.ssh/volsync-rsync-net
gcloud secrets create rsync-net-public-key --data-file ~/.ssh/volsync-rsync-net.pub
echo "your-account.rsync.net ssh-ed25519 AAAA..." | gcloud secrets create rsync-net-host-key --data-file -
```

### 4. Deploy VolSync

```bash
# Sync Flux to deploy VolSync
just flux-sync

# Verify deployment
kubectl get pods -n volsync-system
kubectl get externalsecrets -n volsync-system
```

### 5. Create Your First Backup

- Copy and modify an example from `docs/volsync-examples.md`
- Update with your rsync.net details
- Deploy to your application namespace

## Usage Examples

Detailed examples are available in:

- `docs/volsync.md` - Complete usage guide
- `docs/volsync-examples.md` - Example configurations and real-world usage patterns

## Integration Benefits

- **GitOps**: Managed through existing Flux CD setup
- **Security**: Uses existing External Secrets Operator and Google Secret Manager
- **Monitoring**: Integrates with cluster monitoring stack
- **Storage**: Leverages existing Rook-Ceph for snapshots
- **Consistency**: Follows established cluster patterns and conventions
