terraform {
  backend "remote" {
    organization = "rabbito-home"
    workspaces {
      name = "infra"
    }
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.6.0"
    }
  }
}

provider "digitalocean" {
  # Provider is configured using environment variables:
  # DIGITALOCEAN_TOKEN, DIGITALOCEAN_ACCESS_TOKEN
}

resource "digitalocean_vpc" "nyc1_idm" {
  name   = "idm-nyc1"
  region = "nyc1"
}
