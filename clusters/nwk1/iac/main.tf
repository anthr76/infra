terraform {
  backend "http" {
    address        = "https://gitlab.com/api/v4/projects/27033486/terraform/state/nwk1-cluster-prod"
    lock_address   = "https://gitlab.com/api/v4/projects/27033486/terraform/state/nwk1-cluster-prod/lock"
    unlock_address = "https://gitlab.com/api/v4/projects/27033486/terraform/state/nwk1-cluster-prod/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
  required_providers {
    matchbox = {
      source = "poseidon/matchbox"
      version = "0.4.1"
    }
    minio = {
      source = "aminueza/minio"
      version = "1.2.0"
    }
  }
}

provider "matchbox" {
  endpoint    = "matchbox-rpc.nyc1.rabbito.tech:443"
  client_cert = file("~/.matchbox/client.crt")
  client_key  = file("~/.matchbox/client.key")
  ca          = file("~/.matchbox/ca.crt")
}

# NOTE: This is nessecary until an explanation for https://bugzilla.opensuse.org/show_bug.cgi?id=1188186 is brought to light..
provider "minio" {
  minio_server = "s3.nwk1.rabbito.tech"
  minio_region = "us-east-1"
  minio_access_key = data.sops_file.tf_secrets.data["minio_access_key"]
  minio_secret_key = data.sops_file.tf_secrets.data["minio_secret_key"]
}

resource "minio_s3_object" "autoyast-arm64" {
  bucket_name    = "matchbox-assets"
  object_name    = "autoyast2/kubic-arm64.xml"
  content        = module.nwk1-arm64.autoyast
}

resource "minio_s3_object" "autoyast-amd64" {
  bucket_name    = "matchbox-assets"
  object_name    = "autoyast2/kubic-amd64.xml"
  content        = module.nwk1-amd64-workers.autoyast
}

module "nwk1-arm64" {
  source = "git::https://gitlab.com/kutara/typhoon//bare-metal/opensuse-kubic/kubernetes?ref=opensuse-kubic"

  # bare-metal
  cluster_name            = "nwk1"
  matchbox_http_endpoint  = "https://matchbox.nyc1.rabbito.tech"
  arch = "arm64"
  autoyast_url = "foo"

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
  matchbox_http_endpoint  = "https://matchbox.nyc1.rabbito.tech"
  autoyast_url = "foo"
  ssh_authorized_key = "ssh-rsa AAAAB3N."
  kubeconfig         = module.nwk1-arm64.kubeconfig-admin
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
