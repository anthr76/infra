# The Private IPv4 Addresses of the master droplets
output "master_nodes_private" {
    value = digitalocean_droplet.kubic_master.*.ipv4_address_private
}

# The Private IPv4 Addresses of the worker droplets
output "worker_nodes_private" {
    value = digitalocean_droplet.kubic_worker.*.ipv4_address_private
}
