resource "tfe_workspace" "backblaze" {
  name           = "backblaze"
  organization   = tfe_organization.kutara.name
  execution_mode = "local"
  queue_all_runs = false
}

resource "tfe_workspace" "gcp_kutara" {
  name           = "gcp-kutara"
  organization   = tfe_organization.kutara.name
  execution_mode = "local"
  queue_all_runs = false
}

resource "tfe_workspace" "gcp_top22" {
  name           = "gcp-top22"
  organization   = tfe_organization.kutara.name
  execution_mode = "local"
  queue_all_runs = false
}

resource "tfe_workspace" "gcp_seed" {
  name           = "gcp-seed"
  organization   = tfe_organization.kutara.name
  execution_mode = "local"
  queue_all_runs = false
}

resource "tfe_workspace" "scr1_db" {
  name           = "scr1-db"
  organization   = tfe_organization.kutara.name
  execution_mode = "local"
  queue_all_runs = false
}

resource "tfe_workspace" "scr1_libvirt" {
  name           = "scr1-libvirt"
  organization   = tfe_organization.kutara.name
  execution_mode = "local"
  queue_all_runs = false
}

resource "tfe_workspace" "top22_github" {
  name           = "top-22-github"
  organization   = tfe_organization.kutara.name
  execution_mode = "local"
  queue_all_runs = false
}

resource "tfe_workspace" "top22_cloudflare" {
  name           = "top-22-cloudflare"
  organization   = tfe_organization.kutara.name
  execution_mode = "local"
  queue_all_runs = false
}
