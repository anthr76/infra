module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "5.2.0"
  project_id   = module.kutara-proj-testing.project_id
  network_name = "kutara-homeprod"
  subnets = [
    {
      subnet_name   = "us-central1-subnet-01"
      subnet_ip     = "10.10.0.0/16"
      subnet_region = "us-central1"
    },
  ]
  secondary_ranges = {
    "us-central1-subnet-01" = [
      {
        range_name    = "k8s-pod"
        ip_cidr_range = "10.20.0.0/16"
      },
      {
        range_name    = "k8s-service"
        ip_cidr_range = "10.30.0.0/16"
      },
    ]
  }
}
