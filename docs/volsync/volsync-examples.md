# VolSync Examples

This document contains example configurations for using VolSync with rsync.net as the backing store.

## Prerequisites

Before using these examples, you need to:

1. **Set up an rsync.net account** and configure SSH keys
2. **Add the SSH keys to Google Secret Manager** with the following names:
   - `rsync-net-private-key`: Your private SSH key for connecting to rsync.net
   - `rsync-net-public-key`: Your public SSH key
   - `rsync-net-host-key`: The rsync.net server's host key (can be obtained with `ssh-keyscan your-account.rsync.net`)

3. **Update the example configurations** below with your specific rsync.net details

**Note**: Detailed setup instructions are available in `docs/volsync.md` including how to use gcloud CLI for key management.

## Configuration Details

- **Helm Repository**: Located at `k8s/base/flux-system/helm-chart-repositories/backube-charts.yaml`
- **Secret Store**: Uses the existing `gcp-kutara-prod` ClusterSecretStore at `k8s/base/infra/external-secrets/cluster-secret-store/cluster-secret-store.yaml`
- **Namespace Structure**: VolSync is deployed in its own namespace directory at `k8s/base/volsync-system/` following the 1:1 mapping pattern
- **Key Management**: Use gcloud CLI commands for generating and storing SSH keys in Google Secret Manager

## Example ReplicationSource

Here's an example of how to create a ReplicationSource that backs up a PVC to rsync.net:

```yaml
---
apiVersion: volsync.backube/v1alpha1
kind: ReplicationSource
metadata:
  name: my-app-backup
  namespace: my-namespace
spec:
  sourcePVC: my-app-data  # Name of the PVC to backup
  trigger:
    schedule: "0 2 * * *"  # Daily at 2 AM
  rsync:
    sshKeys: rsync-net-ssh-keys  # Reference to the secret created by external-secrets
    address: "zh1234.rsync.net"  # Replace with your rsync.net server
    path: "/data/backups/my-app"  # Path on rsync.net server
    port: 22
    sshUser: "zh1234"  # Replace with your rsync.net username
    copyMethod: Snapshot  # Create a snapshot before backup
    volumeSnapshotClassName: csi-ceph-blockpool-vsc
```

## Example ReplicationDestination

For disaster recovery, you can also set up a ReplicationDestination to restore from rsync.net:

```yaml
---
apiVersion: volsync.backube/v1alpha1
kind: ReplicationDestination
metadata:
  name: my-app-restore
  namespace: my-namespace
spec:
  rsync:
    capacity: 10Gi  # Size of the destination PVC
    storageClassName: rook-ceph-block  # StorageClass for the destination
    accessModes: ["ReadWriteOnce"]
    copyMethod: Snapshot
    volumeSnapshotClassName: csi-ceph-blockpool-vsc
```

## Real-World Examples

### Home Assistant Backup

```yaml
---
apiVersion: volsync.backube/v1alpha1
kind: ReplicationSource
metadata:
  name: home-assistant-backup
  namespace: home
spec:
  sourcePVC: home-assistant-config
  trigger:
    schedule: "0 3 * * *"  # Daily at 3 AM
  rsync:
    sshKeys: rsync-net-ssh-keys
    address: "zh1234.rsync.net"  # Replace with your rsync.net server
    path: "/data/backups/home-assistant"
    port: 22
    sshUser: "zh1234"  # Replace with your rsync.net username
    copyMethod: Snapshot
    volumeSnapshotClassName: csi-ceph-blockpool-vsc
```

### Database Backup

```yaml
---
apiVersion: volsync.backube/v1alpha1
kind: ReplicationSource
metadata:
  name: postgres-backup
  namespace: database
spec:
  sourcePVC: postgresql-data
  trigger:
    schedule: "0 1 * * *"  # Daily at 1 AM
  rsync:
    sshKeys: rsync-net-ssh-keys
    address: "zh1234.rsync.net"  # Replace with your rsync.net server
    path: "/data/backups/postgresql"
    port: 22
    sshUser: "zh1234"  # Replace with your rsync.net username
    copyMethod: Snapshot
    volumeSnapshotClassName: csi-ceph-blockpool-vsc
---
# Example ReplicationDestination for database restore
apiVersion: volsync.backube/v1alpha1
kind: ReplicationDestination
metadata:
  name: postgres-restore
  namespace: database
spec:
  rsync:
    capacity: 20Gi
    storageClassName: rook-ceph-block
    accessModes: ["ReadWriteOnce"]
    copyMethod: Snapshot
    volumeSnapshotClassName: csi-ceph-blockpool-vsc
```

## Usage Notes

- Replace `zh1234.rsync.net` and `zh1234` with your actual rsync.net account details
- Adjust the `schedule` field to your backup frequency requirements
- Set appropriate `capacity` and `storageClassName` for your needs
- The `path` should be a directory on your rsync.net account where backups will be stored
- Make sure your rsync.net account has sufficient space for your backups
- Use proper VolumeSnapshotClass (`csi-ceph-blockpool-vsc` for Rook-Ceph)

## Security Considerations

- SSH keys are stored in Google Secret Manager and managed by External Secrets Operator
- All communication with rsync.net is encrypted via SSH
- Consider using separate SSH keys specifically for VolSync backups
- Monitor backup success/failure through VolSync resource status and cluster monitoring

## Monitoring and Troubleshooting

### Check Backup Status

```bash
# View all ReplicationSources
kubectl get replicationsource -A

# Check specific backup details
kubectl describe replicationsource home-assistant-backup -n home

# View backup job logs
kubectl logs -n home -l volsync.backube/replication-source=home-assistant-backup
```

### Common Issues

1. **SSH Connection Failures**
   - Verify SSH keys in Google Secret Manager
   - Check rsync.net account status and authorized_keys
   - Test connection: `ssh zh1234@zh1234.rsync.net`

2. **Snapshot Failures**
   - Ensure VolumeSnapshotClass `csi-ceph-blockpool-vsc` is available
   - Check storage class snapshot capabilities
   - Verify sufficient storage space

3. **External Secret Issues**
   - Check External Secrets Operator logs
   - Verify `gcp-kutara-prod` ClusterSecretStore is healthy
   - Ensure proper IAM permissions for Secret Manager access
