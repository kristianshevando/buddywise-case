resource "azurerm_subnet" "subnet" {
  name                                           = var.azure_subnet_name
  resource_group_name                            = var.azure_resource_group_name
  virtual_network_name                           = var.azure_vnet_name
  address_prefixes                               = [var.azure_subnet_address_prefix]
  enforce_private_link_endpoint_network_policies = var.enforce_private_link_endpoint_network_policies

  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      delegation,
    ]
  }
}

resource "azurerm_network_security_group" "network_security_group" {
  count               = var.create_azure_network_security_group ? 1 : 0
  name                = azurerm_subnet.subnet.name
  location            = var.azure_vnet_location
  resource_group_name = var.azure_resource_group_name
  
  tags                = var.common_tags
  
  lifecycle {
    ignore_changes = [
      security_rule,
    ]
  }

  dynamic "security_rule" {
    for_each = var.azure_nsg_rules
    iterator = instance
    content {
      name                       = instance.value.name
      priority                   = instance.value.priority
      direction                  = instance.value.direction
      access                     = "Allow"
      protocol                   = instance.value.protocol
      source_port_range          = "*"
      destination_port_ranges    = instance.value.destination_port_ranges
      source_address_prefix      = instance.value.source_address_prefix
      destination_address_prefix = instance.value.destination_address_prefix
    }
  }

  dynamic "security_rule" {
    for_each = var.inbound_default_deny_rule ? [{}] : []
    content {
      name                       = "deny_inbound_all"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  dynamic "security_rule" {
    for_each = var.outbound_default_deny_rule ? [{}] : []
    content {
      name                       = "deny_outbound_all"
      priority                   = 1000
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "attach_subnet" {
  count                     = var.create_azure_network_security_group ? 1 : 0
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = join(", ", azurerm_network_security_group.network_security_group.*.id)
  depends_on                = [azurerm_subnet.subnet, azurerm_network_security_group.network_security_group]
}

resource "azurerm_key_vault_secret" "subnet-address_prefix" {
  name         = "subnet-address-prefix-${var.azure_vnet_name}-${azurerm_subnet.subnet.name}"
  value        = join(",", azurerm_subnet.subnet.address_prefixes)
  key_vault_id = var.azure_key_vault_id
  depends_on   = [azurerm_subnet.subnet]
}