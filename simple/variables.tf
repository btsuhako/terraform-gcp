# variables to be used with the project factory module

# variable "project_name" {
#   type        = string
#   description = "Only to be used with the project factory module."
# }

# variable "org_id" {
#   type        = string
#   default     = "0"
#   description = "The GCP org ID. '0' is the default for a personal account."
# }

# variable "billing_account" {
#   type        = string
#   description = "copy the value from `gcloud billing accounts list`"
# }

variable "project_id" {
  type        = string
  description = "The GCP project ID. Must be globally unique."
}

variable "gke_cluster_name" {
  type        = string
  description = "Name of the GKE cluster in GCP. Must be unique within a project."
}

variable "vpc_cidr_subnet" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Breaks down a /16 network into 64 /20 VPCs. Currently enough for one VPC per GCP region, similar configuration to GCP VPC auto mode."
}

variable "vpc_network_name" {
  type        = string
  default     = "vpc-01"
  description = "Name of the VPC within the GCP project."
}

variable "vpc_subnet_region" {
  type        = string
  description = "value"
  validation {
    condition     = contains(["asia-east1", "asia-east2", "asia-northeast1", "asia-northeast2", "asia-northeast3", "asia-south1", "asia-south2", "asia-southeast1", "asia-southeast2", "australia-southeast1", "australia-southeast2", "europe-central2", "europe-north1", "europe-southwest1", "europe-west1", "europe-west2", "europe-west3", "europe-west4", "europe-west6", "europe-west8", "europe-west9", "europe-west12", "me-central1", "me-west1", "northamerica-northeast1", "northamerica-northeast2", "southamerica-east1", "southamerica-east2", "us-central1", "us-east1", "us-east4", "us-east5", "us-south1", "us-west1", "us-west2", "us-west3", "us-west4", ], var.vpc_subnet_region)
    error_message = "Invalid GPC region. Must be valid region name."
  }
}
