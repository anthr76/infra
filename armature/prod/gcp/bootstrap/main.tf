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
      version = "4.42.1"
    }
  }
}

provider "google" {
  region = "us-east4"
}
