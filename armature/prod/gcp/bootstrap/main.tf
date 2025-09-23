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
      version = "7.4.0"
    }
  }
}

provider "google" {
  region = "us-east4"
}
