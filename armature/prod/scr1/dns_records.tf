#
# Base records
#

# cluster-0 ingress endpoint
resource "cloudflare_record" "cluster_0_ie" {
  name    = "cluster-0-ie.scr1.rabbito.tech"
  zone_id = data.sops_file.cloudflare_secrets.data["int_zone_id"]
  value   = "50.223.56.162"
  proxied = false
  type    = "A"
}
