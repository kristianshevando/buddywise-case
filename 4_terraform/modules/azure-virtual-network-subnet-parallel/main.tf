resource "azurerm_subnet" "subnet" {
  name                 = lookup(var.innovator_components, "instance_name")
  resource_group_name  = var.azure_resource_group_name
  virtual_network_name = var.azure_vnet_name
  address_prefixes     = var.address_prefixes
  service_endpoints    = lookup(var.innovator_components, "instance_name") == "deploy-vmss" ? [ "Microsoft.Storage" ] : []

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_network_security_group" "network_security_group" {
  name                = azurerm_subnet.subnet.name
  location            = var.azure_vnet_location
  resource_group_name = var.azure_resource_group_name

  tags                = var.common_tags

  lifecycle {
    ignore_changes = [
      security_rule,
    ]
  }

  security_rule {
    name                       = "ingresss-azureloadbalancer-allow"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
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
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
  depends_on                = [azurerm_subnet.subnet, azurerm_network_security_group.network_security_group]
}

resource "azurerm_key_vault_secret" "subnet" {
  name         = "subnet-address-prefix-${azurerm_subnet.subnet.name}"
  value        = join(",", azurerm_subnet.subnet.address_prefixes)
  key_vault_id = var.azure_key_vault_id
  depends_on   = [azurerm_subnet.subnet]
}