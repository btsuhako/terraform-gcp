locals {
  network_01_subnet_01_name         = "${var.vpc_network_name}-subnet-01"
  network_01_subnet_01_pod_name     = "${local.network_01_subnet_01_name}-pod-01"
  network_01_subnet_01_service_name = "${local.network_01_subnet_01_name}-service-01"
  vpc_subnet_pod_ip_cidr_range      = "100.64.0.0/14"
  vpc_subnet_service_ip_cidr_range  = "192.168.0.0/20"
}

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
      subnet_region = var.region
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
  source                        = "./gcp-gke"
  cluster_secondary_range_name  = local.network_01_subnet_01_pod_name
  gke_cluster_name              = var.gke_cluster_name
  network                       = module.vpc.network_name
  project_id                    = var.project_id
  region                        = var.region
  services_secondary_range_name = local.network_01_subnet_01_service_name
  subnetwork                    = module.vpc.subnets_names[0]
}
