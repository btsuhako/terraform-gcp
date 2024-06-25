variable "project_id" {
  type = string
}

variable "gke_cluster_name" {
  type = string
}

variable "region" {
  type        = string
  description = "value"
  validation {
    condition     = contains(["asia-east1", "asia-east2", "asia-northeast1", "asia-northeast2", "asia-northeast3", "asia-south1", "asia-south2", "asia-southeast1", "asia-southeast2", "australia-southeast1", "australia-southeast2", "europe-central2", "europe-north1", "europe-southwest1", "europe-west1", "europe-west2", "europe-west3", "europe-west4", "europe-west6", "europe-west8", "europe-west9", "europe-west12", "me-central1", "me-west1", "northamerica-northeast1", "northamerica-northeast2", "southamerica-east1", "southamerica-east2", "us-central1", "us-east1", "us-east4", "us-east5", "us-south1", "us-west1", "us-west2", "us-west3", "us-west4", ], var.region)
    error_message = "Invalid GPC region. Must be valid region name."
  }
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "cluster_secondary_range_name" {
  type = string
}

variable "services_secondary_range_name" {
  type = string
}
