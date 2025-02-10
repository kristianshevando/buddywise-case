data "azuread_group" "group" {
  display_name     = var.azuread_group_display_name
  security_enabled = var.azuread_group_security_enabled
}