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
    random = {
      source = "hashicorp/random"
      version = "3.1.3"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://root@libvirt-01.scr1.rabbito.tech/system?&no_verify=1"
}
