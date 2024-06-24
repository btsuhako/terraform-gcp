# simple

This is the simple Terraform project that uses community Terraform modules to create a VPC and GKE cluster.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.5 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.34.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 5.34.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.34.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke"></a> [gke](#module\_gke) | terraform-google-modules/kubernetes-engine/google | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-google-modules/network/google | ~> 9.1 |

## Resources

| Name | Type |
|------|------|
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | Name of the GKE cluster in GCP. Must be unique within a project. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID. Must be globally unique. | `string` | n/a | yes |
| <a name="input_vpc_cidr_subnet"></a> [vpc\_cidr\_subnet](#input\_vpc\_cidr\_subnet) | Breaks down a /16 network into 64 /20 VPCs. Currently enough for one VPC per GCP region, similar configuration to GCP VPC auto mode. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_network_name"></a> [vpc\_network\_name](#input\_vpc\_network\_name) | Name of the VPC within the GCP project. | `string` | `"vpc-01"` | no |
| <a name="input_vpc_subnet_region"></a> [vpc\_subnet\_region](#input\_vpc\_subnet\_region) | value | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gke_ca_certificate"></a> [gke\_ca\_certificate](#output\_gke\_ca\_certificate) | The certifcate authority certificate of the GKE cluster. |
| <a name="output_gke_endpoint"></a> [gke\_endpoint](#output\_gke\_endpoint) | The control plane API endpoint for the GKE cluster. |
<!-- END_TF_DOCS -->
