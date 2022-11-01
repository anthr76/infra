module "compute_instance" {
  
  region              = var.region
  zone                = var.zone
  subnetwork          = var.subnetwork
  num_instances       = var.num_instances
  hostname            = "instance-simple"
  instance_template   = module.instance_template.self_link
  deletion_protection = false

  access_config = [{
    nat_ip       = var.nat_ip
    network_tier = var.network_tier
  }, ]
}
