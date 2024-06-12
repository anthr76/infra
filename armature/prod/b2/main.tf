terraform {
  backend "remote" {
    organization = "kutara"
    workspaces {
      name = "backblaze"
    }
  }
  required_version = ">= 1.0.0"
  required_providers {
    b2 = {
      source  = "Backblaze/b2"
      version = "0.8.4"
    }
    google = {
      source  = "hashicorp/google"
      version = "4.85.0"
    }
  }
}

provider "google" {
  project = "kutara-prod-ad74"
  region  = "us-central1"
}

data "google_secret_manager_secret_version" "b2_key_id" {
  secret = "BACKBLAZE_MASTER_KEY_ID"
}

data "google_secret_manager_secret_version" "b2_key" {
  secret = "BACKBLAZE_MASTER_KEY"
}

provider "b2" {
  application_key    = data.google_secret_manager_secret_version.b2_key.secret_data
  application_key_id = data.google_secret_manager_secret_version.b2_key_id.secret_data
}


