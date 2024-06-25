resource "random_pet" "this" {}

resource "google_service_account" "this" {
  account_id   = random_pet.this.id
  display_name = "Service Account for ${var.gke_cluster_name}"
  project      = var.project_id
}

resource "google_container_cluster" "this" {
  name     = var.gke_cluster_name
  location = var.region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  subnetwork               = var.subnetwork

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }
  project = var.project_id
}

resource "google_container_node_pool" "this" {
  name       = "default-node-pool"
  location   = var.region
  cluster    = google_container_cluster.this.name
  node_count = 1

  node_config {
    disk_size_gb    = 100
    disk_type       = "pd-standard"
    image_type      = "COS_CONTAINERD"
    local_ssd_count = 0
    machine_type    = "e2-medium"
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.this.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
  project = var.project_id
}
