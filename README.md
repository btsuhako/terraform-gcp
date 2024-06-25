# terraform-gcp

Repo to initialize GKE cluster in GCP. There are two main directories:

- `advanced` - GCP project with minimum viable Terraform
- `simple` - GCP project using community Terraform modules

```shell
# at minimum, edit `simple/Makefile` to update the PROJECT_ID and BILLING_ACCOUNT
cd simple
make PROJECT_ID=my-project BILLING_ACCOUNT=123-ABC

# or choose your own adventure, edit `advanced/Makefile` to update the PROJECT_ID and BILLING_ACCOUNT
cd advanced
make PROJECT_ID=my-project BILLING_ACCOUNT=123-ABC
```

## Makefile behavior

The `Makefile` drives the initial configuration. At a high-level it does the following:

- Installs needed binaries with Homebrew
- Logs into GCP CLI
- Configures the Terraform variables based on the `Makefile` configuration
- Runs `terraform init` to download necessary modules
- Runs `terraform apply` to create GCP resources
- Updates your local `kubeconfig` with the GKE cluster endpoint configuration.

## Some improvements

- Need to detect if `PROJECT_ID` is already registered in GCP. If so, then skip the creation. Currently if the `PROJECT_ID` isn't in `terraform.tfvars`, then we create the project in GCP, associate its billing, and enable necessary APIs. This step could be more idempotent, or figure out how to use the project factory Terraform module.
- Need to figure out how to use the project factory module with a personal GCP account. I've used this module before in a workgroup, and minimal configuration is needed in that context.
- Instead of using `var.project_id` as a variable to pass around, use something like Terragrunt to template out `provider.tf` files with the project_id configuration. That way the variable won't be copy/pasted around. Similar pattern with the AWS Account ID and Terraform.
- Use something like Dotenv to source environment variables into the `Makefile`
- Terraform state could be persisted to remote storage. With the project factory module, it can create a project bucket, which could be used to store the Terraform remote state within the project.
