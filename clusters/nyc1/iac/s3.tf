resource "digitalocean_spaces_bucket" "nyc1_velero_bucket" {
  name   = "nyc1-cluster-velero"
  region = "nyc3"
}
