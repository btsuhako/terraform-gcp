BILLING_ACCOUNT = ""
GKE_CLUSTER_NAME = "gke-01"
PROJECT_ID = ""
TFVARS_FILE = "terraform.tfvars"
VPC_SUBNET_REGION = "us-west1"

all: install login configure init apply kubeconfig

info:
	@echo BILLING_ACCOUNT = $(BILLING_ACCOUNT)
	@echo GKE_CLUSTER_NAME = $(GKE_CLUSTER_NAME)
	@echo PROJECT_ID = $(PROJECT_ID)
	@echo TFVARS_FILE = $(TFVARS_FILE)
	@echo VPC_SUBNET_REGION = $(VPC_SUBNET_REGION)

install:
	brew bundle
	gcloud components install gke-gcloud-auth-plugin
	tfenv use

login:
	@gcloud auth application-default login

configure-init:
	@touch $(TFVARS_FILE)

configure: configure-init
	@grep -qF 'project_id' $(TFVARS_FILE) || \
	(printf 'project_id = "%s"\n' "$(PROJECT_ID)" >> $(TFVARS_FILE); \
	gcloud projects create "$(PROJECT_ID)"; \
	gcloud billing projects link --billing-account="$(BILLING_ACCOUNT)" "$(PROJECT_ID)"; \
	gcloud services enable cloudresourcemanager.googleapis.com --project "$(PROJECT_ID)"; \
	gcloud services enable compute.googleapis.com --project "$(PROJECT_ID)"; \
	gcloud services enable container.googleapis.com --project "$(PROJECT_ID)"; \
	gcloud services enable servicenetworking.googleapis.com --project "$(PROJECT_ID)"; \
	gcloud services enable identitytoolkit.googleapis.com --project "$(PROJECT_ID)")
	@grep -qF 'gke_cluster_name' $(TFVARS_FILE) || printf 'gke_cluster_name = "%s"\n' "$(GKE_CLUSTER_NAME)" >> $(TFVARS_FILE)
	@grep -qF 'vpc_subnet_region' $(TFVARS_FILE) || printf 'vpc_subnet_region = "%s"\n' "$(VPC_SUBNET_REGION)" >> $(TFVARS_FILE)

init:
	terraform init

apply:
	terraform apply

kubeconfig:
	gcloud container clusters get-credentials $(GKE_CLUSTER_NAME) --region=$(VPC_SUBNET_REGION) --project $(PROJECT_ID)

terraform-docs:
	@terraform-docs markdown . --output-file README.md

billing-account:
	gcloud billing accounts list

.PHONY: all install init configure configure-init apply kubeconfig billing-account
