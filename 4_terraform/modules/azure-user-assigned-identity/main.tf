resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = var.azurerm_user_assigned_identity_name
  resource_group_name = var.azurerm_resource_group_name
  location            = var.location

  tags                = var.common_tags
}