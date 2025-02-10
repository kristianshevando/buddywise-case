output "azurerm_key_vault_name" {
  value = module.azure_mgmt_key_vault.azurerm_key_vault_name
}

output "azurerm_key_vault_mgmt_vm_name" {
  value = module.azure_mgmt_key_vault_mgmt_vm.azurerm_key_vault_name
}

output "azure_mgmt_key_vault_mgmt_vm" {
  value = module.azure_mgmt_key_vault_mgmt_vm.azurerm_key_vault_id
}

output "azurerm_key_vault_id" {
  value = module.azure_mgmt_key_vault.azurerm_key_vault_id
}

output "azurerm_mgmt_resource_group_name" {
  value = module.azure_mgmt_resource_group.resource_group_name
}

output "azurerm_mgmt_resource_group_tags" {
  value = module.azure_mgmt_resource_group.resource_group_tags
}

output "azurerm_mgmt_resource_group_id" {
  value = module.azure_mgmt_resource_group.resource_group_id
}

output "azure_private_dns_zones" {
  value = flatten([values(module.azure_private_dns_zone)[*].azure_private_dns_zones])
}

output "azurerm_mgmt_virtual_network_id" {
  value = module.azure_mgmt_virtual_network.azurerm_virtual_network_id
}

output "azurerm_mgmt_virtual_network_name" {
  value = module.azure_mgmt_virtual_network.azurerm_virtual_network_name
}

output "azurerm_mgmt_virtual_network_address_space" {
  value = module.azure_mgmt_virtual_network.azurerm_virtual_network_address_space
}

output "azurerm_mgmt_virtual_network" {
  value = [{
    resource_group_name   = module.azure_mgmt_resource_group.resource_group_name
    virtual_network_name  = module.azure_mgmt_virtual_network.azurerm_virtual_network_name
    virtual_network_id    = module.azure_mgmt_virtual_network.azurerm_virtual_network_id
  }]
}

output "azurerm_resource_group_location" {
  value = var.LOCATION
}

output "azure_mgmt_virtual_machine_name" {
  sensitive = true
  value = flatten([values(module.azure_mgmt_virtual_machine)[*].azurerm_virtual_machine_list_name])
}

output "azure_managed_service_identity_object" {
  sensitive = true
  value = flatten([for vm in module.azure_mgmt_virtual_machine: vm.azure_managed_service_identity_object])
}

output "azure_private_link_subnet_id" {
  value = module.azure_mgmt_private_link_network_subnet.azurerm_subnet_id
}

output "azurerm_private_endpoint_ipaddress_key_vault" {
  value = module.azure_private_link_mgmt_key_vault.azurerm_private_endpoint_ipaddress
}

output "azurerm_private_endpoint_fqdn_key_vault" {
  value = module.azure_private_link_mgmt_key_vault.azurerm_private_endpoint_fqdn
}

output "azurerm_private_endpoint_ipaddress_key_vault_mgmt_vm" {
  value = module.azure_private_link_mgmt_vm_key_vault.azurerm_private_endpoint_ipaddress
}

output "azurerm_private_endpoint_fqdn_key_vault_mgmt_vm" {
  value = module.azure_private_link_mgmt_vm_key_vault.azurerm_private_endpoint_fqdn
}

output "azurerm_private_endpoint_container_registry_private_dns_zone_configs" {
  value = module.azure_private_link_container_registry.azurerm_private_endpoint_private_dns_zone_configs
}

output "azurerm_private_endpoint_container_registry_id" {
  value = module.azure_private_link_container_registry.azurerm_private_endpoint_id
}

output "azure_dns_relay_enabled" {
  value = var.azure_dns_relay_enabled
}

output "private_ip_addresses" {
  value = flatten([values(module.azure_mgmt_virtual_machine)[*].private_ip_addresses])
}

output "azurerm_virtual_machine_scale_set_id" {
  value = flatten([values(module.azurerm_virtual_machine_linux_scale_sets)[*].azurerm_virtual_machine_scale_set_id_name, values(module.azurerm_virtual_machine_windows_scale_sets)[*].azurerm_virtual_machine_scale_set_id_name])
}

output "azurerm_virtual_machine_scale_set_identity_objects_principal_id" {
  value = flatten([values(module.azurerm_virtual_machine_linux_scale_sets)[*].azurerm_virtual_machine_scale_set_identity_objects_id_name ,values(module.azurerm_virtual_machine_windows_scale_sets)[*].azurerm_virtual_machine_scale_set_identity_objects_id_name])
  sensitive = true
}

output "azurerm_mgmt_virtual_network_subnets_address_space" {
  value = flatten([ module.azure_mgmt_private_link_network_subnet.azure_subnet_output, module.azure_mgmt_bastion_virtual_network_subnet.azure_subnet_output, values(module.azure_mgmt_virtual_network_subnet)[*].azure_subnet_output ])
}

output "azurerm_mgmt_virtual_network_vm_subnets" {
  value = flatten([values(module.azure_mgmt_virtual_network_subnet)[*].azure_subnet_output])
}

output "azurerm_virtual_network_gateway_name" {
  value = flatten([values(module.azure_private_remote_network_access)[*].azurerm_virtual_network_gateway_name])
}

output "azurerm_virtual_network_gateway_vnet" {
  value = flatten([values(module.azure_private_remote_network_access)[*].azurerm_virtual_network_gateway_vnet])
}

output "azurerm_subnet_output" {
  value = flatten([values(module.azure_mgmt_virtual_network_subnet)[*].azurerm_subnet_name_id])
}

output "azurerm_network_security_group_name" {
  value = values(module.azure_mgmt_virtual_network_subnet)[*].azurerm_network_security_group_name
}