/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*************************************************
  Bootstrap GCP Organization.
*************************************************/
locals {
  read_only_sa_roles = [
    "roles/accesscontextmanager.policyReader",
    "roles/billing.viewer",
    "roles/compute.networkViewer",
    "roles/iam.securityReviewer",
    "roles/iam.serviceAccountViewer",
    "roles/logging.viewer",
    "roles/orgpolicy.policyViewer",
    "roles/resourcemanager.organizationViewer",
    "roles/resourcemanager.folderViewer",
    "roles/securitycenter.adminViewer",
    "roles/iam.workloadIdentityPoolViewer"
  ]
}
resource "google_folder" "bootstrap" {
  display_name = "kutara-prod"
  parent       = "organizations/${var.org_id}"
}

module "bootstrap" {
  source  = "terraform-google-modules/bootstrap/google"
  version = "5.0.1"

  org_id                  = var.org_id
  billing_account         = var.billing_account
  group_org_admins        = var.group_org_admins
  group_billing_admins    = var.group_billing_admins
  sa_enable_impersonation = true
  default_region          = "us-east4"
  project_id              = "tf-seed"
  folder_id               = google_folder.bootstrap.id
  sa_org_iam_permissions = [
    "roles/accesscontextmanager.policyAdmin",
    "roles/billing.user",
    "roles/compute.networkAdmin",
    "roles/compute.xpnAdmin",
    "roles/iam.securityAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/logging.configWriter",
    "roles/orgpolicy.policyAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/resourcemanager.folderAdmin",
    "roles/securitycenter.notificationConfigEditor",
    "roles/resourcemanager.organizationViewer",
    "roles/iam.workloadIdentityPoolAdmin"
  ]
}

module "sa_tf_seed_ro" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "4.1.1"
  project_id = module.bootstrap.seed_project_id
  prefix     = ""
  names      = ["tf-seed-viewer"]
  project_roles = [
    "${module.bootstrap.seed_project_id}=>roles/viewer"
  ]
}

resource "google_organization_iam_member" "tf_sa_org_perms" {
  for_each = toset(local.read_only_sa_roles)
  org_id   = var.org_id
  role     = each.value
  member   = "serviceAccount:${module.sa_tf_seed_ro.email}"
}

module "gh_oidc" {
  source              = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version             = "3.0.0"
  project_id          = module.bootstrap.seed_project_id
  pool_id             = "tf-seed-production-environment"
  provider_id         = "tf-seed-production-environment"
  attribute_condition = "attribute.environment==\"production\""
  attribute_mapping = {
    "attribute.actor" : "assertion.actor",
    "attribute.aud" : "assertion.aud",
    "attribute.repository" : "assertion.repository",
    "attribute.environment" : "assertion.environment",
    "google.subject" : "assertion.sub"
  }
  sa_mapping = {
    "tf-seed" = {
      sa_name   = "projects/${module.bootstrap.seed_project_id}/serviceAccounts/${module.bootstrap.terraform_sa_email}"
      attribute = "attribute.repository/anthr76/infra"
    }
  }
}

module "gh_oidc_pr" {
  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version     = "3.0.0"
  project_id  = module.bootstrap.seed_project_id
  pool_id     = "tf-seed-pr"
  provider_id = "tf-seed-pr"
  sa_mapping = {
    "tf-seed" = {
      sa_name   = "projects/${module.bootstrap.seed_project_id}/serviceAccounts/${module.sa_tf_seed_ro.email}"
      attribute = "attribute.repository/anthr76/infra"
    }
  }
}
