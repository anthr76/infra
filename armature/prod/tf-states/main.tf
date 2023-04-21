terraform {
  backend "remote" {
    organization = "kutara"
    workspaces {
      name = "tf-states"
    }
  }
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.44.1"
    }
  }
}

provider "tfe" {
  # Configuration options
}
