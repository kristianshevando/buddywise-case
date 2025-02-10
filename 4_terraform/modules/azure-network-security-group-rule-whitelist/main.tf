resource "azurerm_network_security_rule" "nsg_rule_whitelist" {
  name                         = lookup(var.azure_nsg_rules_whitelist, "name")
  priority                     = lookup(var.azure_nsg_rules_whitelist, "priority")
  direction                    = lookup(var.azure_nsg_rules_whitelist, "direction")
  access                       = lookup(var.azure_nsg_rules_whitelist, "access")
  protocol                     = lookup(var.azure_nsg_rules_whitelist, "protocol")
  source_port_range            = lookup(var.azure_nsg_rules_whitelist, "source_port_range")
  destination_port_ranges      = lookup(var.azure_nsg_rules_whitelist, "destination_port_ranges")
  source_address_prefixes      = lookup(var.azure_nsg_rules_whitelist, "source_address_prefixes")
  source_address_prefix        = lookup(var.azure_nsg_rules_whitelist, "source_address_prefix")
  destination_address_prefixes = var.azure_nsg_rules_whitelist_destination
  resource_group_name          = var.resource_group_name
  network_security_group_name  = var.network_security_group_name
}