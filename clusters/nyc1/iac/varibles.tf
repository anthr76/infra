
variable "count_masters" {
  description = "number of master nodes to be created"
  default     = 3
}

variable "count_workers" {
  description = "number of worker nodes to be created"
  default     = 3
}

variable "count_block_storage" {
  description = "number of a single block device to be created on workers"
  default     = 3
}

variable "control_plane_ip" {
  description = "IP Address of Control plane endpoint"
  default     = "nyc1-lb-1.k8s.rabbito.tech"
}

variable "service_cidr_range" {
  description = "K8s service CIDR"
  default     = "10.42.0.0/16"
}

variable "pod_cidr_range" {
  description = "K8s pod CIDR"
  default     = "10.43.0.0/16"
}

variable "kubeadm_token" {
  type        = string
  description = "The token use for bootstrapping the kubernetes cluster.\nGenerate with: \n$ kubeadm token generate"
  sensitive   = true
}

variable "kubeadm_certificate_key" {
  type        = string
  description = "The key used to encrypt the control-plane certificates.\nGenerate with: \n$ kubeadm alpha certs certificate-key\n"
  sensitive   = true
}

variable "localanthony_ssh_key" {
  description = "SSH user localanthony key"
  sensitive   = true
}
