
output "cluster_ipv4" {
  value = digitalocean_kubernetes_cluster.nyc1.ipv4_address
}

output "cluster_endpoint" {
  value = digitalocean_kubernetes_cluster.nyc1.endpoint
}
