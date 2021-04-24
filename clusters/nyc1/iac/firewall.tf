data "digitalocean_vpc" "nyc1_idm" {
  name = "idm-nyc1"
}

resource "digitalocean_firewall" "k8s-cluster" {
  name = "kubic-controlplane-k8s"
  droplet_ids = concat(digitalocean_droplet.kubic_worker.*.id, digitalocean_droplet.kubic_master.*.id, digitalocean_droplet.kubic_first_master.*.id)

  inbound_rule {
    protocol         = "tcp"
    port_range       = "6443"
    source_load_balancer_uids = [digitalocean_loadbalancer.kubic_k8s.id]
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
    protocol         = "udp"
    port_range       = "1-65535"
    source_addresses = [data.digitalocean_vpc.nyc1_idm.ip_range]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    source_addresses = [data.digitalocean_vpc.nyc1_idm.ip_range]
  }
}
