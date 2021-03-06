output "master_nodes_private" {
  value = concat(digitalocean_droplet.kubic_master.*.ipv4_address_private, digitalocean_droplet.kubic_first_master.*.ipv4_address_private)
}

output "first_master_nodes_private" {
  value = digitalocean_droplet.kubic_first_master.*.ipv4_address_private
}

output "worker_nodes_private" {
  value = digitalocean_droplet.kubic_worker.*.ipv4_address_private
}

output "master_nodes_public" {
  value = concat(digitalocean_droplet.kubic_master.*.ipv4_address, digitalocean_droplet.kubic_first_master.*.ipv4_address)
}

output "first_master_nodes_public" {
  value = digitalocean_droplet.kubic_first_master.*.ipv4_address
}

output "worker_nodes_public" {
  value = digitalocean_droplet.kubic_worker.*.ipv4_address
}

output "load_balancer" {
  value = digitalocean_loadbalancer.kubic_k8s.ip
}
