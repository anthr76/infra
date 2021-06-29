# variable "kubic_aarch64_kernel" {
#   type        = string
#   description = "Location of Kubic kernel"
#   default     = "stable"
# }

# variable "os_version" {
#   type        = string
#   description = "Fedora CoreOS version to PXE and install (e.g. 32.20200715.3.0)"
# }

variable "matchbox_http_endpoint" {
  type        = string
  description = "Readonly matchbox endpoint"
}
