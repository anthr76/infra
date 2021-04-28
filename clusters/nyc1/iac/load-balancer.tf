 resource "digitalocean_loadbalancer" "kubic_k8s" {
  name   = "kubic-lb"
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

  droplet_ids = concat(digitalocean_droplet.kubic_master.*.id, digitalocean_droplet.kubic_first_master.*.id)
}

 resource "digitalocean_loadbalancer" "traefik_lb" {
  name   = "traefik-lb-nyc1"
  region = "nyc1"
  vpc_uuid = data.digitalocean_vpc.nyc1_idm.id
  enable_proxy_protocol = true


  forwarding_rule {
    entry_port     = 80
    entry_protocol = "https"

    target_port     = 80
    target_protocol = "https"
    tls_passthrough = true

  }

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 443
    target_protocol = "https"
    tls_passthrough = true

  }

  healthcheck {
    port     = 443
    protocol = "tcp"
  }

  droplet_ids = digitalocean_droplet.kubic_worker.*.id
}
