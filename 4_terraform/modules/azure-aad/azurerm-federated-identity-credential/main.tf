resource "azurerm_federated_identity_credential" "example" {
  name                = var.azuread_federated_identity_name
  resource_group_name = var.azuread_federated_identity_resource_group_name
  audience            = var.azuread_federated_identity_audience
  issuer              = var.azuread_federated_identity_issuer
  parent_id           = var.azuread_federated_identity_parent_id
  subject             = var.azuread_federated_identity_subject
}