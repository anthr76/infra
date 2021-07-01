resource "matchbox_profile" "kubic_aarch64" {
  name = "kubic-worker-aarch64"
  kernel = "http://s3.nwk1.rabbito.tech/matchbox-assets/kubicaarch64/boot/aarch64/linux"
  initrd = [
    "http://s3.nwk1.rabbito.tech/matchbox-assets/kubicaarch64/boot/aarch64/initrd"
  ]
  args = [
    "ip=dhcp",
    "netsetup=dhcp",
    "install=http://s3.nwk1.rabbito.tech/matchbox-assets/kubicaarch64/",
    "autoyast=http://s3.nwk1.rabbito.tech/matchbox-assets/kubicaarch64/autoyast2/kubicxaarch64.xml",
    "initrd=initrd",
    "linux",
  ]
}

# https://gitlab.com/kutara/infra/-/blob/main/docs/pimatrix.md

resource "matchbox_group" "default_aarch64" {
  name    = "default"
  profile = matchbox_profile.kubic_aarch64.name
  selector ={
    mac = "dc:a6:32:03:59:4d"
  }
}

resource "minio_s3_object" "autoyast_aarch64" {
  bucket_name    = "matchbox-assets"
  object_name    = "kubicaarch64/autoyast2/kubicaarch64.xml"
  content        = file("${path.module}/autoyast-aarch64.xml")
  #etag           = filemd5("./autoyast-aarch64.xml")
}
