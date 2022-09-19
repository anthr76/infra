resource "postgresql_role" "k8s" {
  name     = "k8s"
  login    = true
  password = data.sops_file.tf_secrets.data["k8s_postgres_password"]
}


resource "postgresql_role" "postgres_exporter" {
  name     = "postgres_exporter"
  login    = true
  password = data.sops_file.tf_secrets.data["postgres_exporter_password"]
}

resource "postgresql_grant_role" "postgres_exporter" {
  role       = "postgres_exporter"
  grant_role = "pg_monitor"
  depends_on = [postgresql_role.postgres_exporter]
}

resource "postgresql_database" "my_db" {
  name              = "postgres_exporter"
  owner             = "postgres_exporter"
  template          = "template0"
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true
  depends_on        = [postgresql_role.postgres_exporter]
}

resource "postgresql_database" "paperless" {
  name              = "paperless"
  owner             = "k8s"
  connection_limit  = -1
  allow_connections = true
  depends_on = [
    libvirt_domain.scr1_db,
    postgresql_role.k8s
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
    libvirt_domain.scr1_db,
    postgresql_role.k8s
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
    libvirt_domain.scr1_db,
    postgresql_role.k8s
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
    libvirt_domain.scr1_db,
    postgresql_role.k8s
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
    libvirt_domain.scr1_db,
    postgresql_role.k8s
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
    libvirt_domain.scr1_db,
    postgresql_role.k8s
  ]
}

resource "postgresql_database" "prowlarr_main" {
  name              = "prowlarr-main"
  owner             = "k8s"
  lc_collate        = "C"
  encoding          = "UTF8"
  connection_limit  = -1
  allow_connections = true
  depends_on = [
    libvirt_domain.scr1_db,
    postgresql_role.k8s
  ]
}

resource "postgresql_database" "prowlarr_log" {
  name              = "prowlarr-log"
  owner             = "k8s"
  lc_collate        = "C"
  encoding          = "UTF8"
  connection_limit  = -1
  allow_connections = true
  depends_on = [
    libvirt_domain.scr1_db,
    postgresql_role.k8s
  ]
}

resource "postgresql_database" "grafana" {
  name              = "grafana"
  owner             = "k8s"
  lc_collate        = "C"
  encoding          = "UTF8"
  connection_limit  = -1
  allow_connections = true
  depends_on = [
    libvirt_domain.scr1_db,
    postgresql_role.k8s
  ]
}

resource "postgresql_database" "netbox" {
  name              = "netbox"
  owner             = "k8s"
  lc_collate        = "en_US.utf8"
  encoding          = "UTF8"
  connection_limit  = -1
  allow_connections = true
  depends_on = [
    libvirt_domain.scr1_db,
    postgresql_role.k8s
  ]
}

resource "postgresql_database" "overseerr" {
  name              = "overseerr"
  owner             = "k8s"
  lc_collate        = "en_US.utf8"
  encoding          = "UTF8"
  connection_limit  = -1
  allow_connections = true
  depends_on = [
    libvirt_domain.scr1_db,
    postgresql_role.k8s
  ]
}
