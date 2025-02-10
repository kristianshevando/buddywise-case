data "azurerm_virtual_network" "vnet" {
  count                = length(var.azure_vnets)
  name                 = "${var.infrastructure_name}-${lookup(var.azure_vnets[count.index], "prefix")}-${lookup(var.azure_vnets[count.index], "suffix")}"
  resource_group_name  = "${var.infrastructure_name}-${lookup(var.azure_vnets[count.index], "prefix")}-${lookup(var.azure_vnets[count.index], "suffix")}"
}