# VolSync Examples

This directory contains example configurations for using VolSync with rsync.net as the backing store.

## Prerequisites

Before using these examples, you need to:

1. **Set up an rsync.net account** and configure SSH keys
2. **Add the SSH keys to Google Secret Manager** with the following names:
   - `rsync-net-private-key`: Your private SSH key for connecting to rsync.net
   - `rsync-net-public-key`: Your public SSH key
   - `rsync-net-host-key`: The rsync.net server's host key (can be obtained with `ssh-keyscan your-account.rsync.net`)

3. **Update the example configurations** below with your specific rsync.net details

**Note**: Detailed setup instructions are available in `docs/volsync.md` including how to use the Justfile for key management.

## Configuration Details

- **Helm Repository**: Located at `k8s/base/flux-system/helm-chart-repositories/backube-charts.yaml`
- **Secret Store**: Uses the existing `gcp-kutara-prod` ClusterSecretStore at `k8s/base/infra/external-secrets/cluster-secret-store/cluster-secret-store.yaml`
- **Key Management**: Use the Justfile commands for generating and storing SSH keys in Google Secret Manager

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
    storageClassName: fast-ssd  # StorageClass for the destination
    accessModes: ["ReadWriteOnce"]
    copyMethod: Snapshot
```

## Usage Notes

- Replace `zh1234.rsync.net` and `zh1234` with your actual rsync.net account details
- Adjust the `schedule` field to your backup frequency requirements
- Set appropriate `capacity` and `storageClassName` for your needs
- The `path` should be a directory on your rsync.net account where backups will be stored
- Make sure your rsync.net account has sufficient space for your backups

## Security Considerations

- SSH keys are stored in Google Secret Manager and managed by External Secrets Operator
- All communication with rsync.net is encrypted via SSH
- Consider using separate SSH keys specifically for VolSync backups
- Monitor backup success/failure through VolSync resource status and cluster monitoring
