resource "matchbox_profile" "worker_kubic_amd64" {
  name  = format("%s-%s", var.cluster_name, var.amd64_workers.*.name[count.index])
  count = length(var.amd64_workers)
  kernel = "http://s3.nwk1.rabbito.tech/matchbox-assets/kubicx86/boot/x86_64/loader/linux"
  initrd = [
    "http://s3.nwk1.rabbito.tech/matchbox-assets/kubicx86/boot/x86_64/loader/initrd"
  ]
  args = [
    "ip=dhcp",
    "netsetup=dhcp",
    "install=http://s3.nwk1.rabbito.tech/matchbox-assets/kubicx86",
    "autoyast=http://s3.nwk1.rabbito.tech/matchbox-assets/kubicx86/autoyast2/kubicamd64.xml",
    "initrd=initrd",
    "linux",
  ]
}

resource "matchbox_profile" "master_kubic_aarch64" {
  name  = format("%s-%s", var.cluster_name, var.aarch64_masters.*.name[count.index])
  count = length(var.aarch64_masters)
  kernel = "http://s3.nwk1.rabbito.tech/matchbox-assets/kubicaarch64/boot/aarch64/linux"
  initrd = [
    "http://s3.nwk1.rabbito.tech/matchbox-assets/kubicaarch64/boot/aarch64/initrd"
  ]
  args = [
    "ip=dhcp",
    "netsetup=dhcp",
    "install=http://s3.nwk1.rabbito.tech/matchbox-assets/kubicaarch64/",
    "autoyast=http://s3.nwk1.rabbito.tech/matchbox-assets/kubicaarch64/autoyast2/kubicaarch64.xml",
    "initrd=initrd",
    "linux",
  ]
}

resource "matchbox_profile" "worker_kubic_aarch64" {
  name  = format("%s-%s", var.cluster_name, var.aarch64_workers.*.name[count.index])
  count = length(var.aarch64_workers)
  kernel = "http://s3.nwk1.rabbito.tech/matchbox-assets/kubicaarch64/boot/aarch64/linux"
  initrd = [
    "http://s3.nwk1.rabbito.tech/matchbox-assets/kubicaarch64/boot/aarch64/initrd"
  ]
  args = [
    "ip=dhcp",
    "netsetup=dhcp",
    "install=http://s3.nwk1.rabbito.tech/matchbox-assets/kubicaarch64/",
    "autoyast=http://s3.nwk1.rabbito.tech/matchbox-assets/kubicaarch64/autoyast2/kubicaarch64.xml",
    "initrd=initrd",
    "linux",
  ]
}
