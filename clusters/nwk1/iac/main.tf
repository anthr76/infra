terraform {
  backend "http" {
    address        = "https://gitlab.com/api/v4/projects/27033486/terraform/state/nwk1-cluster-prod"
    lock_address   = "https://gitlab.com/api/v4/projects/27033486/terraform/state/nwk1-cluster-prod/lock"
    unlock_address = "https://gitlab.com/api/v4/projects/27033486/terraform/state/nwk1-cluster-prod/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
  required_providers {
    matchbox = {
      source = "poseidon/matchbox"
      version = "0.4.1"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.6.3"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.8.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.23.0"
    }
    minio = {
      source = "aminueza/minio"
      version = "1.2.0"
    }
  }
}

data "sops_file" "tf_secrets" {
  source_file = "tf-secrets.sops.yaml"
}
provider "matchbox" {
  endpoint    = "matchbox-rpc.nyc1.rabbito.tech:443"
  client_cert = file("~/.matchbox/client.crt")
  client_key  = file("~/.matchbox/client.key")
  ca          = file("~/.matchbox/ca.crt")
}
provider "minio" {
  minio_server = "s3.nwk1.rabbito.tech"
  minio_region = "us-east-1"
  minio_access_key = data.sops_file.tf_secrets.data["minio_access_key"]
  minio_secret_key = data.sops_file.tf_secrets.data["minio_secret_key"]
}
