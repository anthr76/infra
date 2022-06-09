terraform {
  backend "remote" {
    organization = "kutara"
    workspaces {
      name = "scr1-db"
    }
  }
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.14"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.10.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.3.0"
    }
    postgresql = {
      source = "cyrilgdn/postgresql"
      version = "1.16.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://root@libvirt-01.scr1.rabbito.tech/system?&no_verify=1"
}

provider "postgresql" {
  host            = "db-01.scr1.rabbito.tech"
  port            = 5432
  database        = "postgres"
  username        = "db-01"
  password        = data.sops_file.tf_secrets.data["postgres_password"]
  sslmode         = "disable"
  connect_timeout = 90000000
}
