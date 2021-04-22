
variable "count_masters" {
  description = "number of master nodes to be created"
  default     = 3
}

variable "count_workers" {
  description = "number of worker nodes to be created"
  default     = 3
}

variable "control_plane_ip" {
  description = "IP Address of Control plane endpoint"
  default     = "nyc1-lb-1.k8s.rabbito.tech"
}
