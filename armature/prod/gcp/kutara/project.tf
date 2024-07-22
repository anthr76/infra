module "kutara-proj-testing" {
  source            = "terraform-google-modules/project-factory/google"
  version           = "15.0.1"
  name              = "kutara-testing"
  random_project_id = true
  org_id            = var.org_id
  billing_account   = var.billing_account
  activate_apis     = ["compute.googleapis.com", "container.googleapis.com", "cloudbilling.googleapis.com"]
}

module "kutara-proj-prod" {
  source            = "terraform-google-modules/project-factory/google"
  version           = "15.0.1"
  name              = "kutara-prod"
  random_project_id = true
  org_id            = var.org_id
  billing_account   = var.billing_account
  activate_apis     = ["compute.googleapis.com", "container.googleapis.com", "cloudbilling.googleapis.com", "secretmanager.googleapis.com"]
}

