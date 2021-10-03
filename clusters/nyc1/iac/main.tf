terraform {
  backend "http" {
    address        = "https://gitlab.com/api/v4/projects/27033486/terraform/state/kubic-cloud-prod"
    lock_address   = "https://gitlab.com/api/v4/projects/27033486/terraform/state/kubic-cloud-prod/lock"
    unlock_address = "https://gitlab.com/api/v4/projects/27033486/terraform/state/kubic-cloud-prod/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.12.1"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.6.3"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.9.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.1.0"
    }
  }
}

provider "digitalocean" {
  token = data.sops_file.tf_secrets.data["data.do_token"]
  spaces_access_id  = data.sops_file.tf_secrets.data["data.spaces_access_id"]
  spaces_secret_key = data.sops_file.tf_secrets.data["data.spaces_secret_key"]
}

provider "sops" {}

data "sops_file" "tf_secrets" {
  source_file = "tf-secrets.yaml"
}

resource "digitalocean_custom_image" "kubic_image" {
  name    = "kubic_digitalocean"
  url     = "http://download.opensuse.org/tumbleweed/appliances/openSUSE-MicroOS.x86_64-Kubic-kubeadm-DigitalOcean-Cloud.qcow2"
  regions = ["nyc1"]
}

provider "cloudflare" {
  email   = data.sops_file.tf_secrets.data["data.cf_email"]
  api_key = data.sops_file.tf_secrets.data["data.cf_api_key"]
}
