locals {
  coreos_version = "36.20220522.3.0"
  hostname       = "ceph-02"
}

resource "random_uuid" "volume" {
  keepers = {
    # The glue is real yeo. But this was a script then a null provisioner lmfao.
    libvirt_ignition = "${sensitive(libvirt_ignition.core_os_config.content)}"
  }
}

resource "libvirt_volume" "fcos" {
  name             = "fcos-base-${random_uuid.volume.id}"
  format           = "qcow2"
  size             = "20442450944"
  base_volume_name = "fedora-coreos-${local.coreos_version}-qemu.x86_64.qcow2"
  pool             = "default"
}

resource "libvirt_volume" "persist" {
  name   = "ceph-02-var-lib-ceph"
  format = "qcow2"
  size   = "100442450944"
  pool   = "fast-data"
}

data "ct_config" "ceph_02" {
  content      = file("ceph-02.yaml")
  strict       = true
  pretty_print = true
}

resource "libvirt_ignition" "core_os_config" {
  name    = "ceph-02-ignition"
  content = data.ct_config.ceph_02.rendered
}

resource "libvirt_domain" "ceph_02" {
  name            = "ceph-02"
  description     = "Ceph daemon node"
  vcpu            = "2"
  memory          = "6058"
  qemu_agent      = true
  coreos_ignition = libvirt_ignition.core_os_config.id
  autostart       = true
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
    mac          = "52:54:00:b2:2f:86"
  }
}
