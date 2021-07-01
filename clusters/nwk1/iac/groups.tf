resource "matchbox_group" "master_aarch64" {
  name    = format("%s-%s", var.cluster_name, var.aarch64_masters.*.name[count.index])
  count   = length(var.aarch64_masters)
  profile = matchbox_profile.master_kubic_aarch64.*.name[count.index]
  selector = {
    mac = var.aarch64_masters.*.mac[count.index]
  }
}

resource "matchbox_group" "worker_aarch64" {
  name    = format("%s-%s", var.cluster_name, var.aarch64_workers.*.name[count.index])
  count   = length(var.aarch64_workers)
  profile = matchbox_profile.worker_kubic_aarch64.*.name[count.index]
  selector = {
    mac = var.aarch64_workers.*.mac[count.index]
  }
}

resource "matchbox_group" "worker_amd64" {
  count   = length(var.amd64_workers)
  name    = format("%s-%s", var.cluster_name, var.amd64_workers.*.name[count.index])
  profile = matchbox_profile.worker_kubic_amd64.*.name[count.index]
  selector = {
      mac = var.amd64_workers.*.mac[count.index]
  }
}
