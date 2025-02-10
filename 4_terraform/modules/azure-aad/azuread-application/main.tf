data "azuread_client_config" "current" {}

resource "azuread_application" "application" {
  display_name = var.azuread_application_display_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "spn" {
  client_id = azuread_application.application.client_id
}

resource "azuread_application_password" "application" {
  application_id = azuread_application.application.id
  end_date              = "2099-01-01T01:02:03Z"
  depends_on            = [azuread_service_principal.spn]
}