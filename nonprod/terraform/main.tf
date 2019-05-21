provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  environment     = "${var.cloud_name}"

  version = "~> 1.22"
}

terraform {
  required_version = "< 0.12.0"

  backend "azurerm" {
    storage_account_name = "8g86lgef668n3ij36xzx"
    container_name       = "terraforms"
    key                  = "nonprod/terraform.tfstate"
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

module "pas" {
  source = "../../terraforming-azure/modules/pas"

  env_name = "${var.env_name}"
  location = "${var.location}"

  pas_subnet_cidr      = "${var.pcf_pas_subnet}"
  services_subnet_cidr = "${var.pcf_services_subnet}"

  cf_storage_account_name              = "${var.cf_storage_account_name}"
  cf_buildpacks_storage_container_name = "${var.cf_buildpacks_storage_container_name}"
  cf_droplets_storage_container_name   = "${var.cf_droplets_storage_container_name}"
  cf_packages_storage_container_name   = "${var.cf_packages_storage_container_name}"
  cf_resources_storage_container_name  = "${var.cf_resources_storage_container_name}"

  resource_group_name                 = "${module.infra.resource_group_name}"
  dns_zone_name                       = "${module.infra.dns_zone_name}"
  network_name                        = "${module.infra.network_name}"
  bosh_deployed_vms_security_group_id = "${module.infra.bosh_deployed_vms_security_group_id}"
}

module "certs" {
  source = "../../terraforming-azure/modules/certs"

  env_name           = "${var.env_name}"
  dns_suffix         = "${var.dns_suffix}"
  ssl_ca_cert        = "${var.ssl_ca_cert}"
  ssl_ca_private_key = "${var.ssl_ca_private_key}"
}

module "isolation_segment" {
  source = "../../terraforming-azure/modules/isolation_segment"

  count = "${var.isolation_segment ? 1 : 0}"

  environment = "${var.env_name}"
  location    = "${var.location}"

  ssl_cert           = "${var.iso_seg_ssl_cert}"
  ssl_private_key    = "${var.iso_seg_ssl_private_key}"
  ssl_ca_cert        = "${var.iso_seg_ssl_ca_cert}"
  ssl_ca_private_key = "${var.iso_seg_ssl_ca_private_key}"

  resource_group_name = "${module.infra.resource_group_name}"
  dns_zone            = "${module.infra.dns_zone_name}"
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
    "*.${var.env_name}.${var.dns_suffix}",
    "*.apps.${var.env_name}.${var.dns_suffix}",
    "*.sys.${var.env_name}.${var.dns_suffix}",
    "*.login.sys.${var.env_name}.${var.dns_suffix}",
    "*.uaa.sys.${var.env_name}.${var.dns_suffix}"
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