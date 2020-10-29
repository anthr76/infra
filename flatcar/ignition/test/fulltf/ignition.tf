
data "ignition_config" "ignition" {
  count = var.hosts
  users = [
    data.ignition_user.core.rendered,
  ]

  files = [
    element(data.ignition_file.hostname.*.rendered, count.index)
  ]

  networkd = [
    data.ignition_networkd_unit.network-dhcp.rendered,
  ]

  systemd = [
    data.ignition_systemd_unit.optdir.rendered,
    data.ignition_systemd_unit.k3s.rendered,
  ]
}

data "ignition_file" "hostname" {
  filesystem = "root"
  path       = "/etc/hostname"
  mode       = 420

  content {
    content = format(var.hostname_format, count.index + 1)
  }

  count = var.hosts
}

data "ignition_user" "core" {
  name = "core"

  ssh_authorized_keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIWVikHZuTKOhKig6cQwxkoT4DyzLiXgVbySjX4Br9Yxn6gVPHsIBJZT/KH8bfwxVbompToV3sdnLsQSl03kdfkjLFiryeCJ1PvKSY/STfxg3LVcsMX9rrgLriYCxZVvrn5QBBuKmQkpK2KqSiJQKzpWZsi3dKdVsq5D6/pdU62pXOUs1nNogqJHQYRsBzTpgb/iYrpN2JARPBjU3vER3eqDnhUbi9VgsTtcFLuPJpH+o5JMr1PhtvAdXlBPDsbpp0W9qpuUZvdKn/OBEN19NxWTPu+A71fpDN2z8ebJqfqeHxx3vOpZJtTgYwNDlc2pVuZ2be3s1f5CKdwyVxIHAtshTsJF0VPehULQB4RXwNV2sVUr4rox2Fxr8uWRyz4/yudVEl1s/mXeHvK21NPBedHagSu+RSPXMl/5O1tUC0NQ7ZDiJNNYL6BpblSIbFkC/mZQQuX8AuKKzBDyezNJHtiia3wcv32TmfeGb54IgeaLgpCxpo/IDYrCIYvl4sVaqKH1EfbMIB5UpWIW3nAGJfOse8rhn8BjiwhjKfShks8euH5wZkqhiddK2NR43tShxqJvik4t03KVfwg/JqqARJDTioWagSaHcuIutWR7AuNWGQs/8fIJYd4NawbKoEyqEoiaqkwr3fxtijI2i1RpArFDflHIUfFw2nHF/pQ/FDLw== hello@anthonyrabbito.com"]
}

data "ignition_networkd_unit" "network-dhcp" {
  name    = "00-wired.network"
  content = file("${path.module}/units/00-wired.network")
}

data "ignition_systemd_unit" "optdir" {
  name    = "optdir.service"
  enabled = true
  content = file("${path.module}/units/10-optdir.conf")
}

data "ignition_systemd_unit" "k3s" {
  name    = "optdir.service"
  enabled = true
  content = file("${path.module}/units/30-k3s.conf")
}