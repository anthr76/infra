resource "cloudflare_record" "minio" {
  zone_id = data.sops_file.tf_secrets.data["int_zone_id"]
  name    = "s3.nwk1"
  value   = "lb-2.nwk1.rabbito.tech"
  type    = "CNAME"
  ttl     = 1
}
