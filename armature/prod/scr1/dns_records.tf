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

# reverse dns
resource "cloudflare_record" "rdns_3g" {
  zone_id = data.sops_file.cloudflare_secrets.data["int_zone_id"]
  name    = "162.56.223.50.in-addr.arpa"
  type    = "PTR"
  value   = "scr1.rabbito.tech"
}

resource "cloudflare_record" "rdns_1g" {
  zone_id = data.sops_file.cloudflare_secrets.data["int_zone_id"]
  name    = "50.239.94.170.in-addr.arpa"
  type    = "PTR"
  value   = "scr1-alt.rabbito.tech"
}
