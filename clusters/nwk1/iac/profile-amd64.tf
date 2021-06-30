resource "matchbox_profile" "kubic_amd64" {
  name = "kubic-worker-aarch64"
  kernel = "http://s3.nwk1.rabbito.tech/matchbox-assets/kubicx86/boot/x86_64/loader/linux"
  initrd = [
    "http://s3.nwk1.rabbito.tech/matchbox-assets/kubicx86/boot/x86_64/loader/initrd"
  ]
  args = [
    "ip=dhcp",
    "netsetup=dhcp",
    "autoupgrade=1",
    "install=http://s3.nwk1.rabbito.tech/matchbox-assets/kubicax86/",
    "autoyast=http://s3.nwk1.rabbito.tech/matchbox-assets/kubicx86/autoyast2/kubicamd64.xml",
    "initrd=initrd"
  ]
}

resource "matchbox_group" "default_amd64" {
  name    = "default"
  profile = matchbox_profile.kubic_aarch64.name
  selector = {
    mac = "a0:36:9f:ff:ff:ff"
  }
}

resource "minio_s3_object" "autoyast_amd64" {
  bucket_name    = "matchbox-assets"
  object_name    = "kubicx86/autoyast2/kubicamd64.xml"
  content        = file("${path.module}/autoyast-amd64.xml")

}
