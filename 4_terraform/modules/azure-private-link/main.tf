resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.azurerm_private_endpoint_subnet_id
  
  tags = var.common_tags  

  dynamic "private_service_connection" {
    for_each = var.private_service_connection_auto_approvement_disabled ? [] : [{}]
    content {
      name                           = "${var.private_endpoint_name}-privateserviceconnection"
      private_connection_resource_id = var.azurerm_resource_id
      subresource_names              = var.subresource_names != null ? [ var.subresource_names ] : null
      is_manual_connection           = var.private_service_connection_auto_approvement_disabled
    }
  }

  dynamic "private_service_connection" {
    for_each = var.private_service_connection_auto_approvement_disabled ? [{}] : []
    content {
      name                           = "${var.private_endpoint_name}-privateserviceconnection"
      private_connection_resource_id = var.azurerm_resource_id
      subresource_names              = var.subresource_names != null ? [ var.subresource_names ] : null
      is_manual_connection           = var.private_service_connection_auto_approvement_disabled
      request_message                = var.private_service_connection_approvement_request_message
    }
  }

  dynamic "private_dns_zone_group" {
    for_each = var.azurerm_private_dns_zone_id != [] ? [{}] : []
    content {
      name                  = "dns-group"
      private_dns_zone_ids  = var.azurerm_private_dns_zone_id
    }
  }
}