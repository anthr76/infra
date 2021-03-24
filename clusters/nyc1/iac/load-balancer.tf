resource "digitalocean_loadbalancer" "kubic_k8s" {
  name   = "kubic-controlplane-lb"
  region = "nyc1"
  vpc_uuid = data.digitalocean_vpc.nyc1_idm.id

  forwarding_rule {
    entry_port     = 6443
    entry_protocol = "https"

    target_port     = 6443
    target_protocol = "https"

    tls_passthrough = true

  }

  healthcheck {
    port     = 6443
    protocol = "tcp"
  }

  droplet_ids = digitalocean_droplet.kubic_master.*.id
}
