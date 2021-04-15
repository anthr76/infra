terraform {
  backend "remote" {
    organization = "rabbito-home"
    workspaces {
      name = "kubic-cloud-prod"
    }
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.7.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "digitalocean" {
  # Provider is configured using environment variables:
  # DIGITALOCEAN_TOKEN, DIGITALOCEAN_ACCESS_TOKEN
}

provider "kubectl" {
  load_config_file = false
  host  = digitalocean_kubernetes_cluster.nyc1.endpoint
  token = digitalocean_kubernetes_cluster.nyc1.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.nyc1.kube_config[0].cluster_ca_certificate
  )
  apply_retry_count = 5
}

data "digitalocean_vpc" "nyc1_idm" {
  name = "idm-nyc1"
}

# We use DOKS until https://bugzilla.opensuse.org/show_bug.cgi?id=1182227
resource "digitalocean_kubernetes_cluster" "nyc1" {
  name    = "nyc1"
  region  = "nyc1"
  auto_upgrade = true
  surge_upgrade = true
  version = "1.20.2-do.0"
  vpc_uuid = data.digitalocean_vpc.nyc1_idm.id

  node_pool {
    name       = "autoscale-worker-pool"
    size       = "s-2vcpu-2gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 5
  }
}

data "kubectl_path_documents" "kustomization_manifests" {
    pattern = "../gotk/*.yaml"
}

resource "kubectl_manifest" "flux_kustomization" {
    count     = length(data.kubectl_path_documents.kustomization_manifests.documents)
    yaml_body = element(data.kubectl_path_documents.kustomization_manifests.documents, count.index)
}

data "kubectl_path_documents" "gotk_manifests" {
    pattern = "../gotk/flux-system/*.yaml"
}

resource "kubectl_manifest" "flux" {
    count     = length(data.kubectl_path_documents.gotk_manifests.documents)
    yaml_body = element(data.kubectl_path_documents.gotk_manifests.documents, count.index)
}
