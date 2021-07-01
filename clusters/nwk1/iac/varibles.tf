variable "matchbox_http_endpoint" {
  type        = string
  description = "Readonly matchbox endpoint"
}

variable "cluster_name" {
  type        = string
  description = "Unique cluster name"
}

# machines

variable "aarch64_masters" {
  type = list(object({
    name   = string
    mac    = string
    domain = string
  }))
  description = <<EOD
List of controller machine details (unique name, identifying MAC address, FQDN)
[{ name = "node1", mac = "52:54:00:a1:9c:ae", domain = "node1.example.com"}]
EOD
}

variable "amd64_workers" {
  type = list(object({
    name   = string
    mac    = string
    domain = string
  }))
  description = <<EOD
List of worker machine details (unique name, identifying MAC address, FQDN)
[
  { name = "node2", mac = "52:54:00:b2:2f:86", domain = "node2.example.com"},
  { name = "node3", mac = "52:54:00:c3:61:77", domain = "node3.example.com"}
]
EOD
}

variable "aarch64_workers" {
  type = list(object({
    name   = string
    mac    = string
    domain = string
  }))
  description = <<EOD
List of worker machine details (unique name, identifying MAC address, FQDN)
[
  { name = "node2", mac = "52:54:00:b2:2f:86", domain = "node2.example.com"},
  { name = "node3", mac = "52:54:00:c3:61:77", domain = "node3.example.com"}
]
EOD
}
