resource "minio_s3_object" "autoyast_amd64" {
  bucket_name    = "matchbox-assets"
  object_name    = "kubicx86/autoyast2/kubicamd64.xml"
  content        = file("${path.module}/autoyast-amd64.xml")
}

resource "minio_s3_object" "autoyast_aarch64" {
  bucket_name    = "matchbox-assets"
  object_name    = "kubicaarch64/autoyast2/kubicaarch64.xml"
  content        = file("${path.module}/autoyast-aarch64.xml")
}
