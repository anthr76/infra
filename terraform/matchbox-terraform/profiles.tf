// Create a flatcar-install profile
resource "matchbox_profile" "flatcar-install-stable" {
  name   = "flatcar-install"
  kernel = "http://nwk1-app-1:8080/assets/flatcar/2605.7.0/flatcar_production_pxe.vmlinuz"
  initrd = [
    "http://nwk1-app-1:8080/assets/flatcar/2605.7.0/flatcar_production_pxe_image.cpio.gz",
  ]

  args = [
    "initrd=flatcar_production_pxe_image.cpio.gz",
    "flatcar.config.url=${var.matchbox_http_endpoint}/ignition?uuid=$${uuid}&mac=$${mac:hexhyp}",
    "flatcar.first_boot=yes",
    "console=tty0",
    "console=ttyS0",
  ]

  container_linux_config = file("./clc/flatcar-install.yaml")
}

// Profile to set an SSH authorized key on first boot from disk
resource "matchbox_profile" "worker" {
  name                   = "worker"
  container_linux_config = file("./clc/flatcar.yaml")
}
