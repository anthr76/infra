resource "dns_a_record_set" "first_master_node" {
  zone  = "k8s.rabbito.tech."
  count = 1
  name  = "nyc1-master-${count.index + 1}"
  ttl   = 15
  addresses = [element(digitalocean_droplet.kubic_first_master.*.ipv4_address_private, count.index)]
}

resource "dns_a_record_set" "master_nodes" {
  zone  = "k8s.rabbito.tech."
  count = var.count_masters - 1
  name  = "nyc1-master-${count.index + 2}"
  ttl   = 15
  addresses = [element(digitalocean_droplet.kubic_master.*.ipv4_address_private, count.index)]
}

resource "dns_a_record_set" "worker_nodes" {
  zone  = "k8s.rabbito.tech."
  count = var.count_workers
  name  = "nyc1-worker-${count.index + 1}"
  ttl   = 15
  addresses = [element(digitalocean_droplet.kubic_worker.*.ipv4_address_private, count.index)]
}

resource "dns_a_record_set" "load_balancer" {
  zone  = "k8s.rabbito.tech."
  name  = "nyc1-lb-1"
  ttl   = 15
  addresses = [digitalocean_loadbalancer.kubic_k8s.ip]
}

resource "dns_a_record_set" "traefik_lb" {
  zone  = "k8s.rabbito.tech."
  name  = "nyc1-lb-2"
  ttl   = 15
  addresses = [digitalocean_loadbalancer.traefik_lb.ip]
}
