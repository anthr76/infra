locals {
  coreos_version = "35.20220424.3.0"
  hostname       = "db-01"
}

resource "random_uuid" "volume" {
  keepers = {
    # The glue is real yeo. But this was a script then a null provisioner lmfao.
    libvirt_ignition = "${sensitive(libvirt_ignition.core_os_config.content)}"
  }
}

resource "libvirt_volume" "fcos" {
  name   = "fcos-base-${random_uuid.volume.id}"
  format = "qcow2"
  size   = "20442450944"
  base_volume_name = "fedora-coreos-${local.coreos_version}-qemu.x86_64.qcow2"
  pool   = "default"
}

resource "libvirt_volume" "persist" {
  name   = "db-01-var"
  format = "qcow2"
  size   = "50442450944"
  pool   = "fast-data"
}


data "ct_config" "db_01" {
  content      = file("db-01.yaml")
  strict       = true
  pretty_print = true
}

resource "libvirt_ignition" "core_os_config" {
  name    = "db-01-ignition"
  content = data.ct_config.db_01.rendered
}

resource "libvirt_domain" "scr1_db" {
  name        = "scr1-db"
  description = "Database VM for supports K8s."
  vcpu        = "1"
  memory      = "8024"
  qemu_agent  = true
  coreos_ignition = libvirt_ignition.core_os_config.id
  autostart = true
  console {
    type        = "pty"
    target_port = "0"
  }
  disk {
    volume_id = libvirt_volume.fcos.id
  }
  disk {
    volume_id = libvirt_volume.persist.id
  }
  network_interface {
    network_name = "vmnet"
  }
}

output "connections" {
  value = [
    libvirt_domain.scr1_db.*.network_interface.0.addresses
  ]
}
