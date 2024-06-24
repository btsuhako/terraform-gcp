locals {
  network_01_subnet_01_name         = "${var.vpc_network_name}-subnet-01"
  network_01_subnet_01_pod_name     = "${local.network_01_subnet_01_name}-pod-01"
  network_01_subnet_01_service_name = "${local.network_01_subnet_01_name}-service-01"
  vpc_subnet_pod_ip_cidr_range      = "100.64.0.0/14"
  vpc_subnet_service_ip_cidr_range  = "192.168.0.0/20"
}

# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

# Project factory module to be used in an enterprise workgroup
# module "project" {
#   source  = "terraform-google-modules/project-factory/google"
#   version = "~> 15.0"

#   name              = var.project_name
#   random_project_id = true
#   org_id            = var.org_id
#   billing_account   = var.billing_account

#   activate_apis = [
#     "cloudresourcemanager.googleapis.com",
#     "compute.googleapis.com",
#     "container.googleapis.com",
#     "servicenetworking.googleapis.com",
#     "identitytoolkit.googleapis.com",
#   ]
# }

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.1"

  # project_id   = module.project.project_id
  project_id   = var.project_id
  network_name = var.vpc_network_name

  subnets = [
    {
      subnet_name   = local.network_01_subnet_01_name
      subnet_ip     = cidrsubnet(var.vpc_cidr_subnet, 4, 0)
      subnet_region = var.vpc_subnet_region
    }
  ]

  secondary_ranges = {
    (local.network_01_subnet_01_name) = [
      {
        range_name    = "${local.network_01_subnet_01_pod_name}"
        ip_cidr_range = local.vpc_subnet_pod_ip_cidr_range # https://cloud.google.com/kubernetes-engine/docs/concepts/alias-ips#cluster_sizing_secondary_range_pods
      },
      {
        range_name    = "${local.network_01_subnet_01_service_name}"
        ip_cidr_range = local.vpc_subnet_service_ip_cidr_range # https://cloud.google.com/kubernetes-engine/docs/concepts/alias-ips#cluster_sizing_secondary_range_svcs
      },
    ]
  }

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
  ]
}

module "gke" {
  source = "terraform-google-modules/kubernetes-engine/google"
  # project_id = module.project.project_id
  project_id               = var.project_id
  name                     = var.gke_cluster_name
  region                   = module.vpc.subnets_regions[0]
  network                  = module.vpc.network_name
  subnetwork               = module.vpc.subnets_names[0]
  remove_default_node_pool = true
  release_channel          = "REGULAR"
  ip_range_pods            = local.network_01_subnet_01_pod_name
  ip_range_services        = local.network_01_subnet_01_service_name
  # ip_range_pods     = module.vpc.subnets_secondary_ranges[0]
  # ip_range_services = module.vpc.subnets_secondary_ranges[1]

  node_pools = [
    {
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      initial_node_count = 0
      local_ssd_count    = 0
      machine_type       = "e2-medium"
      max_count          = 100
      min_count          = 0
      name               = "default-node-pool"
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
