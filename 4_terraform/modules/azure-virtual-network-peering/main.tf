resource "azurerm_virtual_network_peering" "peering" {
  name                         = "${var.infrastructure_name}-${lookup(var.azure_vnets_peering, "peered_to_prefix")}-${lookup(var.azure_vnets_peering, "peered_to_suffix")}"
  resource_group_name          = "${var.infrastructure_name}-${lookup(var.azure_vnets_peering, "prefix")}-${lookup(var.azure_vnets_peering, "suffix")}"
  virtual_network_name         = join(",", [for instance in var.azure_vnets: element(reverse(split("/", instance.vnet_id)), 0) if element(reverse(split("/", instance.vnet_id)), 0) == "${var.infrastructure_name}-${lookup(var.azure_vnets_peering, "prefix")}-${lookup(var.azure_vnets_peering, "suffix")}"])
  remote_virtual_network_id    = join(",", [for instance in var.azure_vnets: instance.vnet_id if element(reverse(split("/", instance.vnet_id)), 0) == "${var.infrastructure_name}-${lookup(var.azure_vnets_peering, "peered_to_prefix")}-${lookup(var.azure_vnets_peering, "peered_to_suffix")}"])
  allow_virtual_network_access = true
  allow_gateway_transit        = var.azure_virtual_network_gateway_enabled && lookup(var.azure_vnets_peering, "prefix") == "vpn" ? true : false
  use_remote_gateways          = var.azure_virtual_network_gateway_enabled && lookup(var.azure_vnets_peering, "peered_to_prefix") == "vpn" ? true : false
}