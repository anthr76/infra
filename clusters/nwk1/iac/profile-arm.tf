resource "matchbox_profile" "kubic_arm" {
  name = "kubic-worker-aarch64"
  kernel = "https://s3.nwk1.rabbito.tech/matchbox-assets/kubicaarch64/boot/aarch64/linux"
  initrd = [
    "https://s3.nwk1.rabbito.tech/matchbox-assets/kubicaarch64/boot/aarch64/initrd"
  ]
  args = [
    "ip=dhcp",
    "netsetup=dhcp",
    "autoupgrade=1",
    "install=https://s3.nwk1.rabbito.tech/matchbox-assets/kubicaarch64/",
    "autoyast=https://s3.nwk1.rabbito.tech/matchbox-assets/kubicaarch64/autoyast2/kubicxaarch64.xml",
  ]
}

// Default matcher group for machines
resource "matchbox_group" "default" {
  name    = "default"
  profile = matchbox_profile.kubic_arm.name
}


resource "minio_s3_object" "autoyast_aarch64" {
  bucket_name    = "matchbox-assets"
  object_name    = "kubicaarch64/autoyast2/kubicxaarch64.xml"
  source         = "./autoyast-aarch64.xml"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag           = filemd5("./autoyast-aarch64.xml")
}

# // Transpile Fedora CoreOS config to Ignition
# data "ct_config" "worker" {
#   content      = file("worker.yaml")
#   strict       = true
# }


# resource "matchbox_group" "master_1" {
#   name = "master-1"
#   profile = "${matchbox_profile.myprofile.name}"
#   selector = {
#     mac = "52:54:00:a1:9c:ae"
#   }
# }
