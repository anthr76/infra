data "digitalocean_vpc" "nyc1_idm" {
  name = "idm-nyc1"
}

resource "digitalocean_vpc" "nyc1_idm" {
  name   = data.digitalocean_vpc.nyc1_idm.name
  description = data.digitalocean_vpc.nyc1_idm.description
  region = data.digitalocean_vpc.nyc1_idm.region
}

resource "digitalocean_firewall" "web" {
  name = "kubic-k8s"
  droplet_ids = concat(digitalocean_droplet.kubic_worker.*.id, digitalocean_droplet.kubic_master.*.id)

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    #source_addresses = [module.vpc]
  }
}
