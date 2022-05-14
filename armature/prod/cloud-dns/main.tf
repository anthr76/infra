terraform {
  backend "http" {
    address        = "https://gitlab.com/api/v4/projects/27033486/terraform/state/cloud-dns-prod"
    lock_address   = "https://gitlab.com/api/v4/projects/27033486/terraform/state/cloud-dns-prod/lock"
    unlock_address = "https://gitlab.com/api/v4/projects/27033486/terraform/state/cloud-dns-prod/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
  required_providers {
    sops = {
      source  = "carlpett/sops"
      version = "0.7.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.14.0"
    }
  }
}

provider "sops" {}

data "sops_file" "tf_secrets" {
  source_file = "tf-secrets.sops.yaml"
}

provider "cloudflare" {
  email   = data.sops_file.tf_secrets.data["cf_email"]
  api_key = data.sops_file.tf_secrets.data["cf_api_key"]
}
