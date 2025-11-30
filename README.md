# Home Infrastructure

<div align="center">

[![GitHub issues](https://img.shields.io/github/issues/anthr76/infra)](https://github.com/anthr76/infra/issues)
[![GitHub stars](https://img.shields.io/github/stars/anthr76/infra)](https://github.com/anthr76/infra/stargazers)
![GitHub last commit](https://img.shields.io/github/last-commit/anthr76/infra)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=flat-square)](https://github.com/pre-commit/pre-commit)

</div>

---

## 📖 Overview

This repository contains my home infrastructure-as-code, managing Kubernetes clusters, cloud resources, and on-premises virtualization using GitOps principles. Flux watches this repository and applies changes automatically to maintain desired state across my infrastructure.

This is a multi-cloud, multi-environment setup supporting home automation, media services, monitoring, and infrastructure experiments.

**Related Repositories:**
- [anthr76/snowflake](https://github.com/anthr76/snowflake) - System-level configuration (NixOS, routers, nodes)

---

## ⛵ Kubernetes

### Core Components

- [Flux](https://fluxcd.io/) - GitOps operator for Kubernetes
- [Cilium](https://cilium.io/) - eBPF-based container networking (CNI)
- [Rook Ceph](https://rook.io/) - Distributed storage for persistent volumes
- [VolSync](https://volsync.readthedocs.io/) - Asynchronous PVC replication to rsync.net
- [CloudNative-PG](https://cloudnative-pg.io/) - PostgreSQL operator

### Automation & Security

- [Renovate](https://github.com/renovatebot/renovate) - Automated dependency updates
- [External Secrets](https://external-secrets.io/) - Secret synchronization (migrating to Bitwarden Secrets Manager)
- [Reloader](https://github.com/stakater/Reloader) - Automatic pod restarts on config changes

### GitOps Workflow

Flux monitors this Git repository and recursively applies Kustomizations in `k8s/clusters/<cluster-name>/`. Applications are deployed as HelmReleases with dependency management. Renovate watches for updates to container images, Helm charts, and Terraform modules, automatically creating pull requests.

---

## 📂 Repository Structure

```
.
├── armature/prod/          # Production infrastructure (Terraform)
│   ├── cloud-dns/          # Cloudflare DNS management
│   ├── gcp/                # Google Cloud Platform (phasing out)
│   ├── scr1/               # Primary on-premises site (migrating to qgr1)
│   ├── nwk1/               # Secondary network site
│   └── b2/                 # Backblaze B2 storage
├── k8s/                    # Kubernetes manifests
│   ├── base/               # Base configs (namespace = directory name)
│   │   ├── flux-system/    # Flux and HelmRepositories
│   │   ├── home/           # Home automation (Home Assistant, ESPHome)
│   │   ├── media/          # Media services (Plex, qBittorrent)
│   │   ├── monitoring/     # Prometheus, Grafana, Alert Manager
│   │   ├── database/       # PostgreSQL, Redis, CouchDB
│   │   └── ...             # Other namespaces
│   └── clusters/           # Cluster-specific overlays
│       ├── qgr1-cluster-0/ # Primary on-prem cluster
│       └── civo-mgmt-0/    # Management cluster
├── docs/                   # Documentation
└── hack/                   # Utilities and scripts
```

**Key Principles:**
- Each directory under `k8s/base/` maps 1:1 to a Kubernetes namespace
- All HelmRepository resources live in `k8s/base/flux-system/helm-chart-repositories/`
- Cluster-specific overrides use Kustomize overlays in `k8s/clusters/`

---

## ☁️ Cloud Dependencies

While this infrastructure is primarily self-hosted, it relies on some cloud services:

| Service            | Use Case                          | Cost (Approx)      |
|--------------------|-----------------------------------|--------------------|
| Cloudflare         | DNS, CDN, tunnels                 | ~$50/yr            |
| rsync.net          | Off-site PVC backups (VolSync)    | Variable           |
| Terraform Cloud    | Remote state management           | Free tier          |
| Bitwarden          | Secrets management (migrating to) | ~$40/yr            |

---

## 🔧 Infrastructure Stack

### Development & Automation

- [devenv](https://devenv.sh/) - Nix-based development environments
- [just](https://github.com/casey/just) - Task automation (preferred over scripts)
- [pre-commit](https://pre-commit.com/) - Git hooks for YAML linting and secret detection

### Virtualization & OS

- **NixOS** - Declarative Linux distribution for infrastructure nodes

### Monitoring & Observability

- **Prometheus** - Metrics collection
- **Grafana** - Visualization and dashboards
- **Alert Manager** - Alert routing and management

### Applications

- **Home Automation:** Home Assistant, ESPHome, Zigbee2MQTT, Z-Wave JS UI
- **Media:** Plex, qBittorrent, cross-seed
- **Networking:** Unifi Controller
- **Databases:** PostgreSQL (CloudNative-PG), Redis, CouchDB

---

## 🚀 Getting Started

### Prerequisites

This repository uses `devenv` for consistent tooling across environments:

```bash
# Install devenv (if not already installed)
# See: https://devenv.sh/getting-started/

# Enter development environment (automatically installs all tools)
devenv shell

# Or use direnv for automatic activation
direnv allow
```

### Common Tasks

```bash
# List all available automation tasks
just --list

# Reconcile all Flux resources
just flux-reconcile

# Sync Flux GitRepos, Kustomizations, and HelmReleases
just flux-sync

# Suspend/resume Flux resources (useful for maintenance)
just flux-suspend
just flux-resume
```

### Working with Kubernetes

```bash
# Check Flux status
flux get all -A

# Manually reconcile a resource
flux reconcile source git flux-system
flux reconcile kustomization <name>

# View Flux logs
flux logs --all-namespaces
```

---

## 🔄 Active Migrations

This infrastructure is undergoing several significant transitions:

### 1. **Secret Management → Bitwarden Secrets Manager**
Migrating from External Secrets (GCP Secret Manager) to Bitwarden Secrets Manager for all Kubernetes secrets.

### 2. **Terraform Removal**
Infrastructure provisioning moving away from Terraform to configurations managed in [anthr76/snowflake](https://github.com/anthr76/snowflake).

### 3. **OS Migration: NixOS Transition**
Infrastructure nodes migrated to NixOS. Legacy Fedora CoreOS and Talos Linux configurations deprecated.

### 4. **GCP Phase-out**
Google Cloud Platform resources (GKE, Secret Manager) being migrated away.

### 5. **Site Rename: scr1 → qg1**
Primary site designation changing from `scr1` to `qgr1` due to physical relocation. This affects DNS, certificates, cluster names, and monitoring.

---

## 📚 Documentation

- **[CLAUDE.md](./CLAUDE.md)** - Guidance for Claude Code when working with this repository
- **[docs/](./docs/)** - Additional setup guides and documentation
- **[.github/instructions/](./github/instructions/.instructions.md)** - Comprehensive coding standards and guidelines

---

## 🤝 Community & Inspiration

Feel free to open a [GitHub issue](https://github.com/anthr76/infra/issues/new) if you have questions!

**Join the community:**
- [k8s@home Discord](https://discord.gg/5sutTcCav5)

**Inspiration from these amazing repositories:**
- [onedr0p/home-ops](https://github.com/onedr0p/home-ops)
- [bjw-s/k8s-gitops](https://github.com/bjw-s/k8s-gitops)
- [xUnholy/k8s-gitops](https://github.com/xUnholy/k8s-gitops)
- [billimek/k8s-gitops](https://github.com/billimek/k8s-gitops)
- [carpenike/k8s-gitops](https://github.com/carpenike/k8s-gitops)
- [blackjid/homelab-gitops](https://github.com/blackjid/homelab-gitops)
- [IronicBadger/infra](https://github.com/IronicBadger/infra)

---
