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
    sops = {
      source  = "carlpett/sops"
      version = "0.6.2"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.8.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.21.0"
    }
  }
}

provider "digitalocean" {
  # Provider is configured using environment variables:
  # DIGITALOCEAN_TOKEN, DIGITALOCEAN_ACCESS_TOKEN
  spaces_access_id  = data.sops_file.tf_secrets.data["data.spaces_access_id"]
  spaces_secret_key = data.sops_file.tf_secrets.data["data.spaces_secret_key"]
}

provider "sops" {}

data "sops_file" "tf_secrets" {
  source_file = "tf-secrets.yaml"
}

# Upload the Kubic Image
resource "digitalocean_custom_image" "kubic_image" {
  name    = "kubic_digitalocean"
  url     = "http://download.opensuse.org/tumbleweed/appliances/openSUSE-MicroOS.x86_64-Kubic-kubeadm-DigitalOcean-Cloud.qcow2"
  regions = ["nyc1"]
}

provider "cloudflare" {
  email   = data.sops_file.tf_secrets.data["data.cf_email"]
  api_key = data.sops_file.tf_secrets.data["data.cf_api_key"]
}
