resource "postgresql_role" "k8s" {
  name     = "k8s"
  login    = true
  password = data.sops_file.tf_secrets.data["k8s_postgres_password"]
}

resource "postgresql_database" "paperless" {
  name              = "paperless"
  owner             = "k8s"
  connection_limit  = -1
  allow_connections = true
  depends_on = [
    libvirt_domain.scr1_db
  ]
}

resource "postgresql_database" "homeassistant" {
  name              = "hass"
  owner             = "k8s"
  lc_collate        = "C"
  encoding          = "UTF8"
  connection_limit  = -1
  allow_connections = true
  depends_on = [
    libvirt_domain.scr1_db
  ]
}

resource "postgresql_database" "radarr_main" {
  name              = "radarr-main"
  owner             = "k8s"
  lc_collate        = "C"
  encoding          = "UTF8"
  connection_limit  = -1
  allow_connections = true
  depends_on = [
    libvirt_domain.scr1_db
  ]
}

resource "postgresql_database" "radarr_log" {
  name              = "radarr-log"
  owner             = "k8s"
  lc_collate        = "C"
  encoding          = "UTF8"
  connection_limit  = -1
  allow_connections = true
  depends_on = [
    libvirt_domain.scr1_db
  ]
}

resource "postgresql_database" "radarr_uhd_main" {
  name              = "radarr-uhd-main"
  owner             = "k8s"
  lc_collate        = "C"
  encoding          = "UTF8"
  connection_limit  = -1
  allow_connections = true
  depends_on = [
    libvirt_domain.scr1_db
  ]
}

resource "postgresql_database" "radarr_uhd_log" {
  name              = "radarr-uhd-log"
  owner             = "k8s"
  lc_collate        = "C"
  encoding          = "UTF8"
  connection_limit  = -1
  allow_connections = true
  depends_on = [
    libvirt_domain.scr1_db
  ]
}

resource "postgresql_database" "prowlarr_main" {
  name              = "prowlarr_main"
  owner             = "k8s"
  lc_collate        = "C"
  encoding          = "UTF8"
  connection_limit  = -1
  allow_connections = true
  depends_on = [
    libvirt_domain.scr1_db
  ]
}

resource "postgresql_database" "prowlarr_log" {
  name              = "prowlarr_log"
  owner             = "k8s"
  lc_collate        = "C"
  encoding          = "UTF8"
  connection_limit  = -1
  allow_connections = true
  depends_on = [
    libvirt_domain.scr1_db
  ]
}
