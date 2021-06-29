resource "libvirt_volume" "coreos_disk" {
  name             = "nas-1-vm"
  base_volume_name = "fedora-coreos-34.20210529.3.0-qemu.x86_64.qcow2"
  pool             = "default"
  size             = 20442450944
  format           = "qcow2"
}

provider "libvirt" {
  uri = "qemu+ssh://anthonyjrabbito@nas-1/system"
}

locals {
  coreos_version = "34.20210518.3.0"
  hostname       = "nas-1-vm"
}


data "ct_config" "core_os_config" {
  content = templatefile(
    "butane/base_ignition.yaml",
    {
      anthonyjrabbito_ssh_key = data.sops_file.tf_secrets.data["anthonyjrabbito_ssh_key"],
      hostname                = local.hostname,
      CF_API_KEY              = data.sops_file.tf_secrets.data["cf_api_key"]
    },
  )
  strict       = true
  pretty_print = false
}

resource "libvirt_ignition" "core_os_config" {
  name    = "nas-1-ignition"
  content = data.ct_config.core_os_config.rendered
}


# Create the virtual machines
resource "libvirt_domain" "coreos-machine" {
  name   = "nas-1-vm"
  vcpu   = "1"
  memory = "2048"

  ## Use qemu-agent in conjunction with the container
  qemu_agent      = true
  coreos_ignition = libvirt_ignition.core_os_config.id
  autostart       = true
  disk {
    volume_id = libvirt_volume.coreos_disk.id
  }

  # This file is usually present as part of the ovmf firmware package in many
  # Linux distributions.
  firmware = "/usr/share/OVMF/OVMF_CODE.fd"

  nvram {
    # This is the file which will back the UEFI NVRAM content.
    file = "/var/lib/libvirt/qemu/nvram/${local.hostname}_VARS.fd"
  }
  cpu = {
    mode = "host-passthrough"
  }

  # Makes the tty0 available via `virsh console`
  console {
    type        = "pty"
    target_port = "0"
  }

  network_interface {
    network_name   = "sr-iov"
    mac            = "52:54:00:82:f0:16"
    passthrough    = "enp16s0"
    addresses      = ["192.168.4.45"]
    wait_for_lease = false
  }

  filesystem {
    source   = "/mnt/hot-store/libvirt/nas-1-data/container"
    target   = "/host/data/"
    readonly = false
  }
  timeouts {
    create = "2m"
  }
}

# -[Output]-------------------------------------------------------------
output "connections" {
  value = [
    "${local.hostname}.nwk1.rabbito.tech",
    libvirt_domain.coreos-machine.*.network_interface.0.addresses
  ]
}
