data "azurerm_subnet" "subnets" {
  count                = length(var.azure_subnets)
  name                 = lookup(var.azure_subnets[count.index], "subnet_name")
  virtual_network_name = "${var.infrastructure_name}-${lookup(var.azure_subnets[count.index], "prefix")}-${lookup(var.azure_subnets[count.index], "suffix")}"
  resource_group_name  = "${var.infrastructure_name}-${lookup(var.azure_subnets[count.index], "prefix")}-${lookup(var.azure_subnets[count.index], "suffix")}"
}
