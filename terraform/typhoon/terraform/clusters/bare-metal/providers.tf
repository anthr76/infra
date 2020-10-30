provider "matchbox" {
  endpoint    = "nwk1-app-1.rabbito.tech:8081"
  client_cert = file("~/.config/matchbox/client.crt")
  client_key  = file("~/.config/matchbox/client.key")
  ca          = file("~/.config/matchbox/ca.crt")
}

provider "ct" {}