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
  }
}

provider "digitalocean" {
  # Provider is configured using environment variables:
  # DIGITALOCEAN_TOKEN, DIGITALOCEAN_ACCESS_TOKEN
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
