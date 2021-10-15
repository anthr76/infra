#
# Base records
#

# cluster-0 ingress endpoint
resource "cloudflare_record" "cluster_0_ie" {
  name    = "cluster-0-ie.scr1.rabbito.tech"
  zone_id = data.sops_file.cloudflare_secrets.data["int_zone_id"]
  value   = "73.101.222.32"
  proxied = false
  type    = "A"
}
