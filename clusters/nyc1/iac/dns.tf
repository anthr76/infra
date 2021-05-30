resource "cloudflare_record" "first_master_node" {
  zone_id = data.sops_file.tf_secrets.data["data.int_zone_id"]
  count   = 1
  name    = "nyc1-master-${count.index + 1}.nyc1"
  value   = element(digitalocean_droplet.kubic_first_master.*.ipv4_address, count.index)
  type    = "A"
  ttl     = 1
}

resource "cloudflare_record" "master_nodes" {
  zone_id = data.sops_file.tf_secrets.data["data.int_zone_id"]
  count   = var.count_masters - 1
  name    = "nyc1-master-${count.index + 2}.nyc1"
  value   = element(digitalocean_droplet.kubic_master.*.ipv4_address, count.index)
  type    = "A"
  ttl     = 1
}

resource "cloudflare_record" "worker_nodes" {
  zone_id = data.sops_file.tf_secrets.data["data.int_zone_id"]
  count   = var.count_workers
  name    = "nyc1-worker-${count.index + 1}.nyc1"
  value   = element(digitalocean_droplet.kubic_worker.*.ipv4_address, count.index)
  type    = "A"
  ttl     = 1
}

resource "cloudflare_record" "api_lb" {
  zone_id = data.sops_file.tf_secrets.data["data.int_zone_id"]
  name    = "nyc1-lb-1.k8s.rabbito.tech"
  value   = digitalocean_loadbalancer.kubic_k8s.ip
  type    = "A"
  ttl     = 1
}
