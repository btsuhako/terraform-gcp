output "gke_ca_certificate" {
  value       = module.gke.ca_certificate
  description = "The certifcate authority certificate of the GKE cluster."
}

output "gke_endpoint" {
  value       = module.gke.endpoint
  description = "The control plane API endpoint for the GKE cluster."
}
