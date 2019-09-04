provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  environment     = "${var.cloud_name}"

  version = "~> 1.31.0"
}

terraform {
  required_version = "< 0.12.0"

  backend "azurerm" {
    storage_account_name = "pcfrefazureacct"
    container_name       = "terraforms"
    key                  = "control/terraform.tfstate"
  }
}

module "infra" {
  source = "../../terraforming-azure/modules/infra"

  env_name                          = "${var.env_name}"
  location                          = "${var.location}"
  dns_subdomain                     = "${var.dns_subdomain}"
  dns_suffix                        = "${var.dns_suffix}"
  pcf_infrastructure_subnet         = "${var.pcf_infrastructure_subnet}"
  pcf_virtual_network_address_space = "${var.pcf_virtual_network_address_space}"
}

module "ops_manager" {
  source = "../../terraforming-azure/modules/ops_manager"

  env_name = "${var.env_name}"
  location = "${var.location}"

  ops_manager_image_uri  = "${var.ops_manager_image_uri}"
  ops_manager_vm_size    = "${var.ops_manager_vm_size}"
  ops_manager_private_ip = "${var.ops_manager_private_ip}"

  optional_ops_manager_image_uri = "${var.optional_ops_manager_image_uri}"

  resource_group_name = "${module.infra.resource_group_name}"
  dns_zone_name       = "${module.infra.dns_zone_name}"
  security_group_id   = "${module.infra.security_group_id}"
  subnet_id           = "${module.infra.infrastructure_subnet_id}"
}

module "control_plane" {
  source = "../../terraforming-azure/modules/control_plane"

  resource_group_name = "${module.infra.resource_group_name}"
  env_name            = "${var.env_name}"
  dns_zone_name       = "${module.infra.dns_zone_name}"
  cidr                = "${var.plane_cidr}"
  network_name        = "${module.infra.network_name}"

  postgres_username = "${var.postgres_username}"

  location    = "${var.location}"
  external_db = "${var.external_db}"
}

/*****************************
 * Let's Encrypt *
 *****************************/

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "${var.contact_email}"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = "${acme_registration.reg.account_key_pem}"
  common_name               = "${var.env_name}.${var.dns_suffix}"
  subject_alternative_names = [
    "pcf.${var.env_name}.${var.dns_suffix}",
    "plane.${var.env_name}.${var.dns_suffix}",
    "opsman.${var.env_name}.${var.dns_suffix}",
    "concourse.${var.env_name}.${var.dns_suffix}",
    "uaa.${var.env_name}.${var.dns_suffix}",
    "credhub.${var.env_name}.${var.dns_suffix}",
  ]

  dns_challenge {
    provider = "azure"

    config {
      AZURE_CLIENT_ID = "${var.client_id}"
      AZURE_CLIENT_SECRET = "${var.client_secret}"
      AZURE_SUBSCRIPTION_ID = "${var.subscription_id}"
      AZURE_TENANT_ID = "${var.tenant_id}"
      AZURE_RESOURCE_GROUP = "${module.infra.resource_group_name}"
    }
  }
}