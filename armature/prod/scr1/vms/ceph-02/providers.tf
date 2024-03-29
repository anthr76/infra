terraform {
  backend "remote" {
    organization = "kutara"
    workspaces {
      name = "scr1-ceph-02"
    }
  }
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.13.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://root@libvirt-01.scr1.rabbito.tech/system?&no_verify=1"
}

