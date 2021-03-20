terraform {
  backend "remote" {
    organization = "rabbito-home"
    workspaces {
      name = "infra"
    }
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.6.0"
    }
  }
}

provider "digitalocean" {
  # Provider is configured using environment variables:
  # DIGITALOCEAN_TOKEN, DIGITALOCEAN_ACCESS_TOKEN
}

# Upload the Kubic Image
resource "digitalocean_custom_image" "kubic_image" {
  name    = "kubic_openstack"
  url     = "https://download.opensuse.org/tumbleweed/appliances/openSUSE-MicroOS.x86_64-Kubic-kubeadm-OpenStack-Cloud.qcow2"
  regions = ["nyc1"]
}

# Create Kubic master nodes.
resource "digitalocean_droplet" "kubic_master" {
  count              = var.count_masters
  ssh_keys           = [28165998]
  image              = digitalocean_custom_image.kubic_image.id
  region             = "nyc1"
  size               = "s-1vcpu-1gb"
  private_networking = true
  user_data          = file("${path.module}/user_data.sh")
  name               = "kubic-master-${count.index + 1}"
}

# Create Kubic worker nodes
resource "digitalocean_droplet" "kubic_worker" {
  count              = var.count_workers
  ssh_keys           = [28165998]
  image              = digitalocean_custom_image.kubic_image.id
  region             = "nyc1"
  size               = "s-1vcpu-1gb-amd"
  private_networking = true
  user_data          = file("${path.module}/user_data.sh")
  name               = "kubic-worker-${count.index + 1}"
}
