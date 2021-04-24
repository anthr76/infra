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
      source = "carlpett/sops"
      version = "~> 0.6.2"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.8.0"
    }
    dns = {
      source = "hashicorp/dns"
      version = "3.1.0"
    }

  }
}

provider "digitalocean" {
  # Provider is configured using environment variables:
  # DIGITALOCEAN_TOKEN, DIGITALOCEAN_ACCESS_TOKEN
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

provider "dns" {
  update {
    server        = "den.rabbito.tech"
    key_algorithm = "hmac-sha256"
    key_name      = "externaldns."
    key_secret    = data.sops_file.tf_secrets.data["data.dns_tsig_key"]
  }
}
