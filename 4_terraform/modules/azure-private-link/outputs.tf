output "azurerm_private_endpoint_name" {
  value = azurerm_private_endpoint.private_endpoint.name
}

output "azurerm_private_endpoint_ipaddress" {
  value = azurerm_private_endpoint.private_endpoint.private_service_connection[0].private_ip_address
}

output "azurerm_private_endpoint_fqdn" {
  value = var.private_service_connection_auto_approvement_disabled == false && length(azurerm_private_endpoint.private_endpoint.private_dns_zone_configs) > 0  ? azurerm_private_endpoint.private_endpoint.private_dns_zone_configs[0].record_sets[0].fqdn : null
}

output "azurerm_private_endpoint_id" {
  value = azurerm_private_endpoint.private_endpoint.id
}

output "azurerm_private_endpoint_private_dns_zone_configs" {
  value = var.azurerm_private_dns_zone_id != [] ? azurerm_private_endpoint.private_endpoint.private_dns_zone_configs : null
}

output "azurerm_private_endpoint_resource_id" {
  value = "${var.azurerm_resource_id};${azurerm_private_endpoint.private_endpoint.id}"
}