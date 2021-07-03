module "nwk1-arm64" {
  source = "git::https://gitlab.com/kutara/typhoon//bare-metal/opensuse-kubic/kubernetes?ref=opensuse-kubic"

  # bare-metal
  cluster_name            = "nwk1"
  matchbox_http_endpoint  = "https://matchbox.nyc1.rabbito.tech"
  arch = "arm64"

  # configuration
  k8s_domain_name    = "k8s.nwk1.rabbito.tech"
  ssh_authorized_key = "ssh-rsa AAAAB3N."

  # machines
  controllers = [
    {
    name="master-1",
    mac="dc:a6:32:03:59:4d",
    domain="master-1.nwk1.rabbito.tech",
    },
    {
    name="master-2",
    mac="dc:a6:32:03:cf:77",
    domain="master-2.nwk1.rabbito.tech"},
    {
    name="master-3",
    mac="dc:a6:32:03:d2:ff",
    domain="master-3.nwk1.rabbito.tech"
    }
  ]
  workers = [
    {
    name="worker-4",
    mac="dc:a6:32:cc:34:a6",
    domain="worker-4.nwk1.rabbito.tech",
    },
    {
    name="worker-5",
    mac="dc:a6:32:46:d6:3c",
    domain="worker-5.nwk1.rabbito.tech",
    },
    {
    name="worker-6",
    mac="dc:a6:32:39:5d:69",
    domain="worker-6.nwk1.rabbito.tech",
    },
    {
    name="worker-7",
    mac="dc:a6:32:39:76:89",
    domain="worker-7.nwk1.rabbito.tech",
    }
  ]

}

module "nwk1-amd64-workers" {
  source = "git::https://gitlab.com/kutara/typhoon//bare-metal/opensuse-kubic/kubernetes/workers?ref=opensuse-kubic"
  name = "amd64-storage"
  matchbox_http_endpoint  = var.ssh_authorized_key
  ssh_authorized_key = var.ssh_authorized_key
  kubeconfig         = module.nwk1-arm64.kubeconfig
  workers = [
    {
    name="worker-1",
    mac="a0:36:9f:ff:ff:ff",
    domain="worker-1.nwk1.rabbito.tech",
    },
    {
    name="worker-2",
    mac="90:e2:ba:8c:70:3a",
    domain="worker-2.nwk1.rabbito.tech"},
    {
    name="worker-3",
    mac="90:e2:ba:8c:74:98",
    domain="worker-3.nwk1.rabbito.tech"
    }
  ]
}
