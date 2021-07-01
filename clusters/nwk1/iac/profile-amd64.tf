resource "matchbox_profile" "kubic_amd64" {
  name = "kubic-worker-amd64"
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

resource "matchbox_group" "default_amd64" {
  count   = length(var.x86_mac_address)
  name    = "kubic-amd64-${count.index}"
  profile = matchbox_profile.kubic_amd64.name
  selector = {
      mac = var.x86_mac_address[count.index]
  }
}

resource "minio_s3_object" "autoyast_amd64" {
  bucket_name    = "matchbox-assets"
  object_name    = "kubicx86/autoyast2/kubicamd64.xml"
  content        = file("${path.module}/autoyast-amd64.xml")

}
