provider "sops" {}

data "sops_file" "tf_secrets" {
  source_file = "tf-secrets.sops.yaml"
}
