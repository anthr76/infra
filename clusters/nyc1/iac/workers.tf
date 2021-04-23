data "ct_config" "worker" {
  count = var.count_workers
  content = templatefile(
    "butane/base_ignition.yaml",
    {
      localanthony_ssh_key = data.sops_file.tf_secrets.data["data.localanthony_ssh_key"]
    }
  )
  snippets = [
    templatefile(
      "butane/join_worker.yaml",
      {
        control_plane_ip = var.control_plane_ip
        token            = data.sops_file.tf_secrets.data["data.kubeadm_token"]
        count            = (count.index + 1)
        DO_PRIVATE_IPV4  = "$${DO_PRIVATE_IPV4}"
      }
    ),]
  strict       = true
  pretty_print = false
}

# Create Kubic worker nodes
resource "digitalocean_droplet" "kubic_worker" {
  count              = var.count_workers
  ssh_keys           = [28165998]
  image              = digitalocean_custom_image.kubic_image.id
  region             = "nyc1"
  size               = "s-2vcpu-2gb"
  private_networking = true
  user_data          = data.ct_config.worker[count.index].rendered
  name               = "kubic-worker-${count.index + 1}"
}
