terraform {
  backend "http" {
    address        = "https://gitlab.com/api/v4/projects/27033486/terraform/state/nas-1-vm"
    lock_address   = "https://gitlab.com/api/v4/projects/27033486/terraform/state/nas-1-vm/lock"
    unlock_address = "https://gitlab.com/api/v4/projects/27033486/terraform/state/nas-1-vm/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.13.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.13.0"
    }
  }
}

provider "sops" {}

data "sops_file" "tf_secrets" {
  source_file = "tf-secrets.sops.yaml"
}

provider "cloudflare" {
  email   = data.sops_file.tf_secrets.data["cf_email"]
  api_key = data.sops_file.tf_secrets.data["cf_api_key_alt"]
}
