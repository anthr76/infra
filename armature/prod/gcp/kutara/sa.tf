module "external_secrets_sa" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "4.2.0"
  project_id = module.kutara-proj-prod.project_id
  prefix     = "k8s"
  names      = ["external-secrets"]
  project_roles = [
    "${module.kutara-proj-prod.project_id}=>roles/secretmanager.secretAccessor"
  ]
  display_name = "External Secrets Kubernetes"
  description  = "Access to secrets for Kubernetes"
}


