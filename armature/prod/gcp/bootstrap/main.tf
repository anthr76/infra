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
      version = "4.65.2"
    }
  }
}

provider "google" {
  region = "us-east4"
}
