terraform {
  backend "remote" {
    organization = "kutara"
    workspaces {
      name = "gcp-kutara"
    }
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.65.2"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.58.0"
    }
  }
}

provider "google" {
  region = "us-central1"
}

provider "google-beta" {
  region = "us-central1"
}
