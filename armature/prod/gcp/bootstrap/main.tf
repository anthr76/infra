terraform {
  backend "remote" {
    organization = "kutara"
    workspaces {
      name = "gcp-seed"
    }
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.26.0"
    }
  }
}

provider "google" {
  region = "us-east4"
}
