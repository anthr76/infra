terraform {

  backend "remote" {
    organization = "rabbito-home"
    workspaces {
      name = "scr1-dns"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.11.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "2.1.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.6.3"
    }
  }
}

data "sops_file" "cloudflare_secrets" {
  source_file = "tf-secret.sops.yaml"
}

provider "cloudflare" {
  email   = data.sops_file.cloudflare_secrets.data["cloudflare_email"]
  api_key = data.sops_file.cloudflare_secrets.data["cloudflare_apikey"]
}

