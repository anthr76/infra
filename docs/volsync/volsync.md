# VolSync Setup and Usage

VolSync is a Kubernetes operator that enables asynchronous replication of persistent volumes. In the SCR1 cluster, VolSync is configured to backup data to rsync.net for off-site storage and disaster recovery.

## Architecture

- **VolSync Operator**: Deployed in the `volsync-system` namespace
- **SSH Keys**: Managed via External Secrets Operator and stored in Google Secret Manager
- **Backup Destination**: rsync.net (external SSH-accessible storage)
- **Storage Classes**: Uses Rook-Ceph for source volumes and snapshots

## Prerequisites

Before using VolSync, ensure you have:

1. **rsync.net Account**: Set up an account at [rsync.net](https://rsync.net)
2. **SSH Key Pair**: Generate dedicated SSH keys for VolSync backups
3. **Google Secret Manager**: Store the SSH keys in the `kutara-prod-ad74` project

## Setting up SSH Keys

### 1. Generate SSH Keys

Generate SSH keys for VolSync backups manually:

```bash
# Generate SSH key pair specifically for VolSync
ssh-keygen -t ed25519 -f ~/.ssh/volsync-rsync-net -C "volsync@scr1-cluster"

# The private key will be at ~/.ssh/volsync-rsync-net
# The public key will be at ~/.ssh/volsync-rsync-net.pub
```

### 2. Configure rsync.net

1. Log into your rsync.net account
2. Add the public key to your account's authorized_keys
3. Test the connection: `ssh your-account@your-account.rsync.net`
4. Get the server's host key: `ssh-keyscan your-account.rsync.net`

### 3. Store Keys in Google Secret Manager

Store the keys in Google Secret Manager using gcloud CLI:

```bash
# Store private key
gcloud secrets create rsync-net-private-key --data-file ~/.ssh/volsync-rsync-net

# Store public key
gcloud secrets create rsync-net-public-key --data-file ~/.ssh/volsync-rsync-net.pub

# Store host key (from ssh-keyscan output)
echo "your-account.rsync.net ssh-ed25519 AAAA..." | gcloud secrets create rsync-net-host-key --data-file -
```

## Configuration Files

### Helm Repository

- **Location**: `k8s/base/flux-system/helm-chart-repositories/backube-charts.yaml`
- **Purpose**: Provides access to the VolSync Helm chart

### External Secrets

- **Location**: `k8s/base/volsync-system/secrets/`
- **Purpose**: Retrieves SSH keys from Google Secret Manager
- **Secret Store**: Uses the existing `gcp-kutara-prod` ClusterSecretStore

### VolSync Operator

- **Location**: `k8s/base/volsync-system/helm-release.yaml`
- **Namespace**: `volsync-system`
- **Security**: Runs with restricted security context and dropped capabilities

## Usage Examples

Detailed examples are available in `docs/volsync-examples.md` including:

- Basic PVC backup and restore configurations
- Real-world examples for Home Assistant and database backups
- Monitoring and troubleshooting guides
- Common usage patterns and best practices

## Monitoring

### Check Backup Status

```bash
# View ReplicationSource status
kubectl get replicationsource -A

# Check specific backup details
kubectl describe replicationsource my-app-backup -n my-app-namespace

# View backup job logs
kubectl logs -n my-app-namespace -l volsync.backube/replication-source=my-app-backup
```

### Common Issues

1. **SSH Connection Failures**
   - Verify SSH keys in Google Secret Manager
   - Check rsync.net account status and authorized_keys
   - Validate network connectivity from cluster

2. **Snapshot Failures**
   - Ensure VolumeSnapshotClass is available
   - Check storage class snapshot capabilities
   - Verify sufficient storage space

3. **Permission Issues**
   - Confirm External Secrets Operator has access to secrets
   - Check RBAC permissions for VolSync operator

## Integration with Existing Infrastructure

- **Flux CD**: VolSync is deployed via Flux using GitOps principles
- **External Secrets**: Leverages the existing `gcp-kutara-prod` ClusterSecretStore
- **Rook-Ceph**: Uses existing storage infrastructure for snapshots
- **Monitoring**: Integrates with cluster monitoring for alerting

## Security Considerations

- SSH keys are stored securely in Google Secret Manager
- VolSync operator runs with restricted security context
- All network communication is encrypted via SSH
- Separate SSH keys should be used specifically for VolSync
- Regular key rotation is recommended

## Maintenance

### Updating VolSync

VolSync is managed via Helm and Flux:

```bash
# Sync Flux to get latest configurations
just flux-sync

# Check VolSync version
kubectl get helmrelease volsync -n volsync-system -o yaml
```

### Key Rotation

To rotate SSH keys:

1. Generate new SSH key pair
2. Update rsync.net authorized_keys
3. Update secrets in Google Secret Manager
4. External Secrets will automatically sync the new keys
5. Remove old keys from rsync.net after verification
