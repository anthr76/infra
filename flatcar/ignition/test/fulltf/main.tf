
terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.2"
    }
    ignition = {
      source = "terraform-providers/ignition"
    }
    random = {
      source = "hashicorp/random"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

variable "hosts" {
  default = 3
}

variable "hostname_format" {
  type    = string
  default = "k3s-node-%02d"
}

resource "libvirt_volume" "flatcar-disk" {
  name             = "flatcar-${format(var.hostname_format, count.index + 1)}.qcow2"
  count            = var.hosts
  base_volume_name = "flatcar_production_qemu_image.img"
  pool             = "flatcar-linux"
  format           = "qcow2"
}

resource "libvirt_ignition" "ignition" {
  name    = "${format(var.hostname_format, count.index + 1)}-ignition"
  pool    = "flatcar-linux"
  count   = var.hosts
  content = element(data.ignition_config.ignition.*.rendered, count.index)
}

resource "libvirt_domain" "node" {
  count  = var.hosts
  name   = format(var.hostname_format, count.index + 1)
  vcpu   = 2
  memory = 2048

  disk {
    volume_id = element(libvirt_volume.flatcar-disk.*.id, count.index)
  }

  network_interface {
    network_name   = "default"
    mac            = "52:54:00:00:00:a${count.index + 1}"
    wait_for_lease = true
  }

  coreos_ignition = element(libvirt_ignition.ignition.*.id, count.index)
  fw_cfg_name     = "opt/org.flatcar-linux/config"
}
