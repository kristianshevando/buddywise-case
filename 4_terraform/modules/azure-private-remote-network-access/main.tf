module "azure_mgmt_resource_group_vpn_gateway" {
  source = "../azure-resource-group"
  providers = {
    azurerm = azurerm
  }

  azure_resource_group_name     = "${var.infrastructure_name}-vpn-gateway-${var.infrastructure_prefix}-${var.azure_virtual_network_gateway_region_index}"
  azure_resource_group_location = var.azure_virtual_network_gateway_region
  common_tags                   = var.common_tags
}

module "azure_mgmt_public_ip_vpn_gateway" {
  source = "../azure-public-ip"
  providers = {
    azurerm = azurerm
  }

  count               = var.azure_virtual_network_gateway_enabled ? 1 : 0

  name                = "${var.infrastructure_name}-vpn-gateway-${var.infrastructure_prefix}-${var.azure_virtual_network_gateway_region_index}"
  location            = var.azure_virtual_network_gateway_region
  resource_group_name = module.azure_mgmt_resource_group_vpn_gateway.resource_group_name
  allocation_method   = var.azure_virtual_network_gateway_public_ip_allocation_method
  sku                 = var.azure_virtual_network_gateway_public_ip_sku
  domain_name_label   = "${var.infrastructure_name}-vpn-gateway-${var.infrastructure_prefix}-${var.azure_virtual_network_gateway_region_index}"
  azure_key_vault_id  = var.azure_key_vault_id
  availability_zones  = length(var.azure_virtual_network_gateway_availability_zones) > 0 && var.azure_virtual_network_gateway_public_ip_sku != "Basic" ? var.azure_virtual_network_gateway_availability_zones : null
  common_tags         = var.common_tags
}

module "azure_mgmt_virtual_network_vpn_gateway" {
  source = "../azure-virtual-network"
  providers = {
    azurerm = azurerm
  }

  azure_vnet_name           = "${var.infrastructure_name}-vpn-gateway-${var.infrastructure_prefix}-${var.azure_virtual_network_gateway_region_index}"
  azure_vnet_location       = var.azure_virtual_network_gateway_region
  azure_resource_group_name = module.azure_mgmt_resource_group_vpn_gateway.resource_group_name
  azure_vnet_address_space  = var.azure_virtual_network_gateway_vnet_address_space
  azure_vnet_dns_servers    = var.azure_virtual_network_gateway_vnet_dns_servers
  result_to_key_vault       = false
  common_tags               = var.common_tags
}

module "azure_mgmt_vpn_gateway_virtual_network_subnet" {
  source = "../azure-virtual-network-subnet"
  providers = {
    azurerm = azurerm
  }

  azure_vnet_name                                = module.azure_mgmt_virtual_network_vpn_gateway.azurerm_virtual_network_name
  azure_resource_group_name                      = module.azure_mgmt_resource_group_vpn_gateway.resource_group_name
  azure_subnet_name                              = "GatewaySubnet"
  azure_subnet_address_prefix                    = cidrsubnet(element(module.azure_mgmt_virtual_network_vpn_gateway.azurerm_virtual_network_address_space, 0), var.azure_virtual_network_gateway_subnet_additional_bitmask, 0)
  azure_key_vault_id                             = var.azure_key_vault_id
  enforce_private_link_endpoint_network_policies = false
  azure_vnet_location                            = var.azure_virtual_network_gateway_region
  create_azure_network_security_group            = false
}

module "azure_mgmt_private_endpoint_virtual_network_subnet" {
  source = "../azure-virtual-network-subnet"
  providers = {
    azurerm = azurerm
  }

  azure_vnet_name                                = module.azure_mgmt_virtual_network_vpn_gateway.azurerm_virtual_network_name
  azure_resource_group_name                      = module.azure_mgmt_resource_group_vpn_gateway.resource_group_name
  azure_subnet_name                              = "PrivateEndpointSubnet"
  azure_subnet_address_prefix                    = cidrsubnet(element(module.azure_mgmt_virtual_network_vpn_gateway.azurerm_virtual_network_address_space, 0), var.azure_virtual_network_private_endpoint_subnet_additional_bitmask, 1)
  azure_key_vault_id                             = var.azure_key_vault_id
  enforce_private_link_endpoint_network_policies = false
  azure_vnet_location                            = var.azure_virtual_network_gateway_region
  create_azure_network_security_group            = false
}

module "azure_mgmt_virtual_network_gateway" {
  source = "../azure-virtual-network-gateway"
  providers = {
    azurerm = azurerm
  }

  count                                = var.azure_virtual_network_gateway_enabled ? 1 : 0

  azurerm_virtual_network_gateway_name = "${var.infrastructure_name}-vpn-gateway-${var.infrastructure_prefix}-${var.azure_virtual_network_gateway_region_index}"
  location                             = var.azure_virtual_network_gateway_region
  azure_resource_group_name            = module.azure_mgmt_resource_group_vpn_gateway.resource_group_name
  azure_subnet_id                      = module.azure_mgmt_vpn_gateway_virtual_network_subnet.azurerm_subnet_id
  public_ip_address_id                 = module.azure_mgmt_public_ip_vpn_gateway[0].public_ip_id
  gateway_type                         = var.azure_virtual_network_gateway_type
  vpn_type                             = var.azure_virtual_network_gateway_vpn_type
  active_active                        = var.azure_virtual_network_gateway_active_active
  enable_bgp                           = var.azure_virtual_network_gateway_enable_bgp
  sku                                  = var.azure_virtual_network_gateway_sku
  generation                           = var.azure_virtual_network_gateway_generation
  common_tags                          = var.common_tags
  depends_on                           = [module.azure_mgmt_resource_group_vpn_gateway, module.azure_mgmt_vpn_gateway_virtual_network_subnet, module.azure_mgmt_public_ip_vpn_gateway]
}