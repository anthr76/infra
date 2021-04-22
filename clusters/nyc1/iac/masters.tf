data "ct_config" "first_master" {
  count = 1
  content = templatefile(
    "butane/base_ignition.yaml",
    {
      localanthony_ssh_key = data.sops_file.tf_secrets.data["data.localanthony_ssh_key"]
    },
  )
  snippets = [
    templatefile(
      "butane/init_master.yaml",
      {
        control_plane_ip = var.control_plane_ip
        certificate_key  = data.sops_file.tf_secrets.data["data.kubeadm_certificate_key"]
        token            = data.sops_file.tf_secrets.data["data.kubeadm_token"]
        count            = (count.index + 1)
      }
    ),
  ]
  strict       = true
  pretty_print = false
}

data "ct_config" "master" {
  count = (var.count_masters - 1) # account for the inital master
  content = templatefile(
    "butane/base_ignition.yaml",
    {
      localanthony_ssh_key = data.sops_file.tf_secrets.data["data.localanthony_ssh_key"]
    }
  )
  snippets = [
    templatefile(
      "butane/join_master.yaml",
      {
        control_plane_ip = var.control_plane_ip
        certificate_key  = data.sops_file.tf_secrets.data["data.kubeadm_certificate_key"]
        token            = data.sops_file.tf_secrets.data["data.kubeadm_token"]
        count            = (count.index + 1)
      }
    ),
  ]
  strict       = true
  pretty_print = false
}


# Create Kubic master nodes.
resource "digitalocean_droplet" "kubic_first_master" {
  count              = 1
  ssh_keys           = [28165998]
  image              = digitalocean_custom_image.kubic_image.id
  region             = "nyc1"
  size               = "s-2vcpu-2gb"
  private_networking = true
  user_data          = data.ct_config.first_master[count.index].rendered
  name               = "kubic-master-${count.index + 1}"
}

# Create Kubic master nodes.
resource "digitalocean_droplet" "kubic_master" {
  count              = var.count_masters - 1
  ssh_keys           = [28165998]
  image              = digitalocean_custom_image.kubic_image.id
  region             = "nyc1"
  size               = "s-2vcpu-2gb"
  private_networking = true
  user_data          = data.ct_config.master[count.index].rendered
  name               = "kubic-master-${count.index + 2}"
}
