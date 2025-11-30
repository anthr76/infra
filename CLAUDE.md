# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a multi-environment, multi-cloud infrastructure-as-code repository for a home lab environment using GitOps principles. It manages Terraform configurations for cloud resources, Kubernetes workloads via Flux CD, and on-premises virtualization.

**Related Repositories:**
- [anthr76/snowflake](https://github.com/anthr76/snowflake) - System-level configuration for nodes, routers, and infrastructure components

**Additional Context:**
- See `.github/instructions/.instructions.md` for comprehensive coding standards and guidelines

## Development Environment

This repository uses `devenv` (Nix-based development environments) for consistent tooling. All required tools are automatically available:

```bash
# Enter the development environment (automatically via direnv or manually)
devenv shell

# All tools are now available: kubectl, terraform, flux, helm, sops, age, just, etc.
```

**Never manually install tools** - they are managed via `devenv.nix`. If you need a new tool, add it to `devenv.nix`.

## Common Commands

### Task Automation
All automation tasks are defined in the `Justfile`. Use `just` instead of custom scripts:

```bash
# List all available tasks
just --list

# Reconcile all Flux GitRepositories and Kustomizations
just flux-reconcile

# Sync Flux GitRepos, Kustomizations, and HelmReleases
just flux-sync

# Suspend all Flux resources
just flux-suspend

# Resume all Flux resources
just flux-resume

# Install Fedora CoreOS for RPI4 (legacy - being phased out)
just burn-fcos-pi4
```

### Kubernetes Operations

```bash
# Switch cluster context
kubectl config use-context <context-name>

# Manually reconcile a specific Flux resource
flux reconcile source git flux-system
flux reconcile kustomization <name>

# Check Flux status
flux get all -A

# View Flux logs
flux logs --all-namespaces
```

### Terraform Operations

```bash
# Format Terraform files
terraform fmt -recursive

# Plan changes
cd armature/prod/<environment>/<service>
terraform plan

# Apply changes
terraform apply
```

### Secret Management

```bash
# Decrypt a SOPS-encrypted file
sops -d <file>.sops.yaml

# Encrypt a file with SOPS
sops -e <file>.yaml > <file>.sops.yaml

# Edit encrypted file in-place
sops <file>.sops.yaml
```

## Architecture

### Directory Structure

- **`armature/prod/`** - Production infrastructure Terraform configurations
  - `cloud-dns/` - Cloudflare DNS management
  - `gcp/` - Google Cloud Platform resources (bootstrap, projects: kutara, top22) - **Being phased out for Talos**
  - `scr1/` - Primary on-premises site (VMs, FCOS configs, switch configs)
  - `nwk1/` - Secondary network site
  - `b2/` - Backblaze B2 storage buckets
  - `tf-states/` - Terraform state configurations

- **`k8s/`** - Kubernetes manifests
  - `base/` - Base Kustomize configurations (each subdirectory = namespace)
  - `clusters/` - Cluster-specific overlays (qgr1-cluster-0, civo-mgmt-0)
  - `rbac/` - RBAC configurations

- **`docs/`** - Infrastructure documentation

### Kubernetes Namespace Organization

**Critical Rule:** Each directory under `k8s/base/` maps 1:1 to a Kubernetes namespace.

Examples:
- `k8s/base/flux-system/` → `flux-system` namespace
- `k8s/base/home/` → `home` namespace
- `k8s/base/media/` → `media` namespace
- `k8s/base/volsync-system/` → `volsync-system` namespace

Namespaces include: database, default, federation, flux-system, home, infra, kube-system, media, monitoring, networking, rook-ceph, volsync-system, kamaji-system, tailscale, tenant-cluster-qgr1, external-secrets, reloader, descheduler, node-feature-discovery.

### Terraform Organization

- **Remote State:** Managed in Terraform Cloud (organizations: "kutara", "rabbito-home")
- **Provider Versions:** Always pinned in `required_providers` blocks
- **Secrets:** Stored in `*.sops.yaml` files, loaded via data sources
- **Naming Convention:** `{service}-{environment}-{resource_type}`

Standard Terraform files: `main.tf`, `variables.tf`, `providers.tf`, `outputs.tf`, `*.sops.yaml`

### GitOps with Flux

- **Flux Operator:** Used for managing Flux installation (see `k8s/base/flux-system/flux-operator/`)
- **HelmRepositories:** All HelmRepository CRs belong in `k8s/base/flux-system/helm-chart-repositories/`
- **Kustomize:** Used for all configuration management
- **Cluster Overlays:** Located in `k8s/clusters/<cluster-name>/`
- **Secret Management:** Migrating to Bitwarden Secrets Manager (see migration notes below)

## Critical Guidelines

### Dependency Management with Renovate

**All version updates go through Renovate.** Renovate manages:
- Container image tags in HelmReleases and Kubernetes manifests
- Helm chart versions in HelmRelease `spec.chart.spec.version`
- Terraform module versions
- GitHub Actions versions

Configuration: `.github/renovate.json5`

**Never manually update versions that Renovate manages.** Always pin specific versions rather than using `latest` or floating tags.

### Kubernetes Best Practices

1. **Namespace Mapping:** Follow the 1:1 directory-to-namespace mapping in `k8s/base/`
2. **HelmRepositories:** Always add to `k8s/base/flux-system/helm-chart-repositories/`
3. **Secret Management:** Migrating to Bitwarden Secrets Manager - see migration notes
4. **Resource Management:** Always specify resource requests/limits
5. **Versioning:** Pin chart versions and container images for Renovate tracking
6. **Labels:** Apply consistent labels: `app.kubernetes.io/name`, `app.kubernetes.io/component`
7. **NetworkPolicies:** Implement for security isolation
8. **Monitoring:** Add monitoring for all custom applications

### Terraform Best Practices

1. **Provider Versions:** Always pin in `required_providers` blocks
2. **Module Versioning:** Pin module versions for Renovate to manage
3. **State Management:** Use Terraform Cloud remote backends
4. **Secret Handling:** Use SOPS for sensitive variables (`*.sops.yaml`)
5. **Formatting:** Run `terraform fmt` before committing
6. **Variable Validation:** Implement proper validation and descriptions

### Security

- **SOPS:** All secrets encrypted with age keys (see `.sops.yaml` for rules)
- **Pre-commit Hooks:** Run automatically to prevent secret leaks (see `.pre-commit-config.yaml`)
- **Secret Management:** Migrating from External Secrets to Bitwarden Secrets Manager
- **IAM:** Implement least-privilege policies
- **Audit Logging:** Enabled for critical resources

### Automation and Scripting

- **Prefer Justfile:** Use `just` commands over custom shell scripts
- **Avoid Custom Scripts:** Tasks should be in the Justfile
- **Development Tools:** Managed via `devenv.nix`, not system installation
- **Task Documentation:** All Justfile tasks have clear descriptions

## Technology Stack

### Cloud & Infrastructure
- **Terraform:** IaC provisioning (state in Terraform Cloud) - **Being phased out for most infra**
- **Google Cloud Platform:** Cloud infrastructure, GKE, Secret Manager - **Being phased out**
- **Cloudflare:** DNS management and CDN
- **NixOS:** Declarative Linux distribution for infrastructure nodes

### Kubernetes Stack
- **Flux CD:** GitOps continuous delivery operator
- **Kustomize:** Configuration management
- **Helm:** Package management via HelmReleases
- **MetalLB:** Load balancer for bare metal
- **Cilium:** Container networking (CNI) with Gateway API
- **Rook Ceph:** Distributed storage
- **VolSync:** Asynchronous PVC replication to rsync.net for backup
- **External Secrets:** Secret synchronization - **Being replaced by Bitwarden Secrets Manager**
- **CloudNative-PG:** PostgreSQL operator

### Key Applications
- **Home Automation:** Home Assistant, ESPHome, Zigbee2MQTT, Z-Wave JS UI
- **Media:** Plex ecosystem, qBittorrent, cross-seed
- **Monitoring:** Prometheus, Grafana, Alert Manager
- **Networking:** Unifi Controller
- **Databases:** PostgreSQL, Redis, CouchDB

## Active Migrations & Important Maintenance Notes

### 1. Secret Management: Migrating to Bitwarden Secrets Manager

**Status:** Active Migration

The cluster is migrating away from External Secrets (GCP Secret Manager) to **Bitwarden Secrets Manager** for all secrets.

**Impact:**
- External Secrets Operator and `gcp-kutara-prod` ClusterSecretStore are being phased out
- All secret references will use Bitwarden Secrets Manager
- SOPS remains for repository-level encrypted secrets

**When adding new secrets:**
- Use Bitwarden Secrets Manager instead of External Secrets
- Avoid creating new ExternalSecret resources
- Check existing patterns for Bitwarden integration

### 2. Infrastructure Management: Terraform Removal

**Status:** Active Migration

Terraform is being removed for all or mostly all infrastructure managed in the [anthr76/snowflake](https://github.com/anthr76/snowflake) repository.

**Impact:**
- Infrastructure provisioning moving away from Terraform
- System-level configuration managed entirely in snowflake repository
- `armature/prod/` Terraform configurations may become legacy

**When making infrastructure changes:**
- Consider if the change should be in snowflake repository instead
- Be aware Terraform configs may be deprecated soon

### 3. OS Migration: NixOS Transition

**Status:** Completed/Active

**Infrastructure nodes have migrated to NixOS.** Fedora CoreOS (FCOS) and Talos Linux configurations are now legacy.

**Impact:**
- FCOS configurations in `armature/prod/scr1/fcos/` are deprecated
- Just recipe `burn-fcos-pi4` is obsolete
- New infrastructure nodes use NixOS (managed in snowflake repository)
- Talos-specific infrastructure deprecated

### 4. GCP Phase-out

**Status:** Active Migration

**Google Cloud Platform (GCP) is being phased out.**

**Impact:**
- `armature/prod/gcp/` configurations becoming legacy
- GKE and GCP-specific resources being migrated away
- Secret Manager (GCP) being replaced by Bitwarden

### 5. Critical Migration: scr1 → qg1

**Status:** High Priority, Breaking Change Required

The `scr1` site designation needs migration to `qg1` due to physical infrastructure relocation. This affects:
- DNS records (`*.scr1.rabbito.tech`)
- Terraform states and resource references
- Kubernetes cluster names and ingress
- TLS certificates
- Monitoring dashboards and alerts
- VM hostnames and network configs

When making changes involving `scr1`, be aware this will eventually be renamed to `qg1`.

### 6. Dead Code Cleanup

The repository contains significant commented/dead code that needs cleanup:
- Commented Terraform resource blocks (especially in `armature/prod/b2/buckets.tf`, GKE configs)
- Unused Kubernetes manifests
- Legacy VM definitions
- FCOS-related configurations

When making changes, consider cleaning up obviously unused commented code in the same area.

## VolSync Backup Strategy

VolSync is used for PVC backup and disaster recovery:
- **ReplicationSource:** Configured for PVCs requiring backup
- **Destination:** rsync.net for off-site storage
- **Scheduling:** Defined per-application in namespace configurations
- **Namespace:** Resources in `k8s/base/volsync-system/`

Documentation: `docs/volsync/`

## Working with Flux

### Cluster Structure

- **Primary Cluster:** qgr1-cluster-0 (on-premises)
- **Management Cluster:** civo-mgmt-0

Cluster overlays in: `k8s/clusters/<cluster-name>/`

### Flux Resource Organization

```
k8s/base/flux-system/
├── cluster-config/          # Cluster-specific configurations
├── flux-operator/           # Flux operator installation
├── helm-chart-repositories/ # All HelmRepository CRs
├── monitoring/              # Flux monitoring setup
├── notifications/           # Flux notifications
└── webhook/                 # Flux webhook receivers
```

### Common Flux Patterns

1. **Adding a HelmRepository:** Always place in `k8s/base/flux-system/helm-chart-repositories/`
2. **Adding a HelmRelease:** Place in appropriate namespace directory under `k8s/base/<namespace>/`
3. **Using Secrets:** Transitioning to Bitwarden Secrets Manager
4. **Cluster-specific overrides:** Use Kustomize overlays in `k8s/clusters/<cluster>/`

## Pre-commit Hooks

Configured in `.pre-commit-config.yaml`:
- yamllint for YAML validation
- Trailing whitespace and EOF fixes
- SOPS secret detection (forbid-secrets)
- Line ending normalization

Run manually: `pre-commit run --all-files`

## Cross-Repository Impact

When making infrastructure changes affecting system-level configurations (networking, storage, security policies), consider the impact on the [anthr76/snowflake](https://github.com/anthr76/snowflake) repository which manages host-level configuration.

With the ongoing Terraform removal, most infrastructure changes will likely belong in the snowflake repository rather than this one.

## Gateway and Domain Patterns

### Cilium Gateway API

This cluster uses Cilium Gateway API for HTTP routing with two main gateways in the `kube-system` namespace:

- **cilium-internal**
  - For internal-only services
  - Domain pattern: `*.qgr1.rabbito.tech`

- **cilium-external**
  - For publicly accessible services
  - Domain pattern: `*.kutara.io`

### HTTPRoute Configuration

All applications should use `HTTPRoute` resources instead of traditional Ingress objects.

**Internal Service Example:**
```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: example-app
  namespace: media
spec:
  parentRefs:
    - name: cilium-internal
      namespace: kube-system
  hostnames:
    - example-app.qgr1.rabbito.tech
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /
      backendRefs:
        - name: example-app
          port: 80
```

**External Service Example:**
```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: example-app
  namespace: media
spec:
  parentRefs:
    - name: cilium-external
      namespace: kube-system
  hostnames:
    - example-app.kutara.io
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /
      backendRefs:
        - name: example-app
          port: 80
```

### Domain Assignments

**Internal Services (qgr1.rabbito.tech)** - Most media and automation services that don't need public access:
- prowlarr.qgr1.rabbito.tech
- sonarr.qgr1.rabbito.tech
- radarr.qgr1.rabbito.tech
- bazarr.qgr1.rabbito.tech
- autobrr.qgr1.rabbito.tech
- qb.qgr1.rabbito.tech
- cross-seed.qgr1.rabbito.tech
- tautulli.qgr1.rabbito.tech
- nzbget.qgr1.rabbito.tech

**External Services (kutara.io)** - Publicly accessible services:
- plex.kutara.io - Plex media server
- requests.kutara.io - Overseerr request management

**TLS Configuration:** Certificates are managed by cert-manager using Let's Encrypt. Gateway resources handle certificate management at the gateway level rather than individual HTTPRoutes.

## Media Namespace Conventions

### App Template Chart

All media applications use the bjw-s `app-template` Helm chart (version 4.x+) from the `bjw-s` HelmRepository in the `flux-system` namespace.

**Standard HelmRelease structure:**
```yaml
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: app-name
  namespace: media
spec:
  interval: 30m
  chart:
    spec:
      chart: app-template
      version: 4.x.x
      sourceRef:
        kind: HelmRepository
        name: bjw-s
        namespace: flux-system
  values:
    controllers:
      app-name:
        containers:
          app:
            # Container configuration
```

### Security Context Standard

All applications run with hardened security contexts:

```yaml
pod:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    runAsGroup: 1000
    fsGroup: 1000
    fsGroupChangePolicy: OnRootMismatch
    seccompProfile:
      type: RuntimeDefault

containers:
  app:
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
          - ALL
```

### Persistence Patterns

**Config Storage** - Each application has its own config PVC (separate PersistentVolumeClaim resource):

```yaml
# config-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-name-config-v1
  namespace: media
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: fast-ceph-block

# In HelmRelease values:
persistence:
  config:
    existingClaim: app-name-config-v1
```

**Shared Media Storage** - Most applications mount the shared `media-v2` PVC:

```yaml
persistence:
  media:
    existingClaim: media-v2
    globalMounts:
      - path: /media
```

**Temporary Storage** - For temporary files and caches:

```yaml
persistence:
  tmp:
    type: emptyDir
    globalMounts:
      - path: /tmp
```

### Image Tag Patterns

- Use SHA256-pinned tags for reproducibility
- Format: `version@sha256:hash`
- Example: `ghcr.io/onedr0p/plex:1.42.2@sha256:9ad8a3506e1d8ebda873a668603c1a2c10e6887969564561be669efd65ae8871`

### Health Probes

Standard liveness and readiness probes using HTTP endpoints:

```yaml
probes:
  liveness:
    enabled: true
  readiness:
    enabled: true
  startup:
    enabled: true
    spec:
      failureThreshold: 30
      periodSeconds: 10
```

Common health endpoints:
- Arr apps (Radarr, Sonarr, Prowlarr): `/ping`
- Bazarr: `/health`
- Plex: `/identity`
- Tautulli: `/status`
- Autobrr: `/api/healthz/liveness`

### Resource Limits

Standard resource limits by application type:

- **Lightweight apps** (10m CPU, 1Gi RAM): Prowlarr, Bazarr, Tautulli, Autobrr
- **Media processing** (100m CPU, 4-8Gi RAM): Radarr, Sonarr, Nzbget
- **Heavy apps** (100m CPU, 16Gi RAM): Plex
- **Torrent clients** (10m CPU, 512Mi RAM): qbittorrent

### App-Template Migration (v1/v2 → v4)

The v4 chart uses a different structure:

**Old (v1/v2):**
```yaml
values:
  image:
    repository: ...
  service:
    main:
      ports:
        http:
          port: 80
```

**New (v4):**
```yaml
values:
  controllers:
    app-name:
      containers:
        app:
          image:
            repository: ...
  service:
    app:
      controller: app-name
      ports:
        http:
          port: 80
```

### UID/GID Changes

When changing security context from 568:568 to 1000:1000, you may need to fix permissions on PVCs:

```bash
kubectl exec -it <pod-name> -n media -- chown -R 1000:1000 /config
```

Or use an init container:

```yaml
initContainers:
  fix-permissions:
    image: busybox:latest
    command: ['sh', '-c', 'chown -R 1000:1000 /config']
    volumeMounts:
      - name: config
        mountPath: /config
```

## Additional Resources

- **Detailed Guidelines:** See `.github/instructions/.instructions.md` for comprehensive coding standards, file organization, and Kubernetes/Terraform best practices
- **Documentation:** Check `docs/` directory for specific setup guides (VolSync, secrets, etc.)
- **Community:** [k8s@home Discord](https://discord.gg/5sutTcCav5)
