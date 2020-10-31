// Configure the matchbox provider
provider "matchbox" {
  endpoint    = var.matchbox_rpc_endpoint
  client_cert = file("~/.config/matchbox/client.crt")
  client_key  = file("~/.config/matchbox/client.key")
  ca          = file("~/.config/matchbox/ca.crt")
}

terraform {
  required_providers {
    ct = {
      source  = "poseidon/ct"
      version = "0.6.1"
    }
    matchbox = {
      source = "poseidon/matchbox"
      version = "0.4.1"
    }
  }
}