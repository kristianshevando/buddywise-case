output "azurerm_virtual_network_gateway_name" {
    value = length(module.azure_mgmt_virtual_network_gateway) > 0  ?  module.azure_mgmt_virtual_network_gateway[0].azurerm_virtual_network_gateway_name : null

}

output "azurerm_virtual_network_gateway_resource_group_name" {
  value = module.azure_mgmt_resource_group_vpn_gateway.resource_group_name
}

output "azurerm_virtual_network_gateway_vnet" {
  value = {
    resource_group_name      = module.azure_mgmt_resource_group_vpn_gateway.resource_group_name
    virtual_network_name     = module.azure_mgmt_virtual_network_vpn_gateway.azurerm_virtual_network_name
    virtual_network_id       = module.azure_mgmt_virtual_network_vpn_gateway.azurerm_virtual_network_id
    virtual_network_location = var.azure_virtual_network_gateway_region
  }
}