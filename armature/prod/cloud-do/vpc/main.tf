terraform {
  backend "remote" {
    organization = "rabbito-home"
    workspaces {
      name = "core"
    }
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.19.0"
    }
  }
}

provider "digitalocean" {
  # Provider is configured using environment variables:
  # DIGITALOCEAN_TOKEN, DIGITALOCEAN_ACCESS_TOKEN
}

resource "digitalocean_vpc" "nyc1_idm" {
  name   = var.vpc_name
  description = var.vpc_description
  region = var.vpc_region
}
