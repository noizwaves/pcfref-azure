output "cidr" {
  value = "${var.cidr}"
}

output "postgres_fqdn" {
  value = "${element(concat(azurerm_postgresql_server.plane.*.fqdn, list("")), 0)}"
}

output "postgres_password" {
  value = "${random_string.postgres_password.result}"
}

output "postgres_username" {
  value = "${var.postgres_username}@${element(concat(azurerm_postgresql_server.plane.*.name, list("")), 0)}"
}

output "plane_lb_name" {
  value = "${azurerm_lb.plane.name}"
}

output "dns_name" {
  value = "${azurerm_dns_a_record.plane.name}.${azurerm_dns_a_record.plane.zone_name}"
}

output "network_name" {
  value = "${azurerm_subnet.plane.name}"
}

output "subnet_gateway" {
  value = "${cidrhost(var.cidr, 1)}"
}

output "storage_account_name" {
  value = "${azurerm_storage_account.control_plane_storage_account.name}"
}

output "storage_account_key" {
  value = "${azurerm_storage_account.control_plane_storage_account.primary_access_key}"
  sensitive = true
}

output "products_container_name" {
  value = "${azurerm_storage_container.products_storage_container.name}"
}

output "backups_container_name" {
  value = "${azurerm_storage_container.backups_storage_container.name}"
}

output "terraform_states_container_name" {
  value = "${azurerm_storage_container.terraform_state_storage_container.name}"
}
