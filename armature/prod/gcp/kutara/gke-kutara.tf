# This should be in another state dir
# But it's for testing and personal so staying here for now.


# module "gke-kutara" {
#   source                            = "terraform-google-modules/kubernetes-engine/google"
#   version                           = "23.2.0"
#   project_id                        = module.kutara-proj-testing.project_id
#   name                              = "kutara-cluster-arm"
#   region                            = "us-central1"
#   zones                             = ["us-central1-a", "us-central1-b", "us-central1-f"]
#   network                           = module.vpc.network_name
#   subnetwork                        = module.vpc.subnets_names[0]
#   ip_range_pods                     = "k8s-pod"
#   ip_range_services                 = "k8s-service"
#   release_channel                   = "RAPID"
#   create_service_account            = true
#   remove_default_node_pool          = true
#   disable_legacy_metadata_endpoints = false

#   node_pools = [
#     {
#       name         = "arm-02"
#       min_count    = 1
#       max_count    = 3
#       spot         = true
#       auto_upgrade = true
#       autoscaling  = false
#       disk_size_gb = 50
#       machine_type = "t2a-standard-1"
#     }

#   ]

#   node_pools_metadata = {
#     pool-01 = {
#       shutdown-script = "kubectl --kubeconfig=/var/lib/kubelet/kubeconfig drain --force=true --ignore-daemonsets=true --delete-local-data \"$HOSTNAME\""
#     }
#   }

#   node_pools_tags = {
#     all = [
#       "all-nodes",
#     ]
#     pool-01 = [
#       "pool-01-arm64",
#     ]
#   }

#   node_pools_taints = {
#     all    = []
#     arm-02 = []
#   }

# }
