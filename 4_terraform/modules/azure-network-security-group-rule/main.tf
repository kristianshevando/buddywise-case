resource "azurerm_network_security_rule" "nsg_rule" {
  name                         = lookup(var.azure_nsg_rules, "name")
  priority                     = lookup(var.azure_nsg_rules, "priority")
  direction                    = lookup(var.azure_nsg_rules, "direction")
  access                       = lookup(var.azure_nsg_rules, "access")
  protocol                     = lookup(var.azure_nsg_rules, "protocol")
  source_port_range            = lookup(var.azure_nsg_rules, "source_port_range")
  destination_port_ranges      = lookup(var.azure_nsg_rules, "destination_port_ranges")
  source_address_prefixes      = lookup(var.azure_nsg_rules, "source_subnet_name") != "*" && lookup(var.azure_nsg_rules, "source_subnet_name") != "Internet" && lookup(var.azure_nsg_rules, "source_subnet_name") != "VirtualNetwork" ? [for instance in var.azure_subnets: instance.address_prefixes if instance.instance_name == lookup(var.azure_nsg_rules, "source_subnet_name")] : null
  source_address_prefix        = lookup(var.azure_nsg_rules, "source_subnet_name") == "*" || lookup(var.azure_nsg_rules, "source_subnet_name") == "Internet" || lookup(var.azure_nsg_rules, "source_subnet_name") == "VirtualNetwork" ? lookup(var.azure_nsg_rules, "source_subnet_name") : null
  destination_address_prefixes = lookup(var.azure_nsg_rules, "destination_subnet_name") != "*" && lookup(var.azure_nsg_rules, "destination_subnet_name") != "Internet" && lookup(var.azure_nsg_rules, "destination_subnet_name") != "VirtualNetwork" ? [for instance in var.azure_subnets: instance.address_prefixes if instance.instance_name == lookup(var.azure_nsg_rules, "destination_subnet_name")] : null
  destination_address_prefix   = lookup(var.azure_nsg_rules, "destination_subnet_name") == "*" || lookup(var.azure_nsg_rules, "destination_subnet_name") == "Internet" || lookup(var.azure_nsg_rules, "destination_subnet_name") == "VirtualNetwork" ? lookup(var.azure_nsg_rules, "destination_subnet_name") : null
  resource_group_name          = var.azure_resource_group_name != null ? var.azure_resource_group_name :"${var.infrastructure_name}-${lookup(var.azure_nsg_rules, "prefix")}-${lookup(var.azure_nsg_rules, "suffix")}"
  network_security_group_name  = lookup(var.azure_nsg_rules, "azure_nsg_name")
}