# simple

This is the advanced Terraform project that uses the VPC community module and a self-authored GKE module.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke"></a> [gke](#module\_gke) | ./gcp-gke | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-google-modules/network/google | ~> 9.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | Name of the GKE cluster in GCP. Must be unique within a project. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID. Must be globally unique. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | value | `string` | n/a | yes |
| <a name="input_vpc_cidr_subnet"></a> [vpc\_cidr\_subnet](#input\_vpc\_cidr\_subnet) | Breaks down a /16 network into 64 /20 VPCs. Currently enough for one VPC per GCP region, similar configuration to GCP VPC auto mode. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_network_name"></a> [vpc\_network\_name](#input\_vpc\_network\_name) | Name of the VPC within the GCP project. | `string` | `"vpc-01"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->