output "azuread_application_display_name" {
  value = azuread_application.application.display_name
}

output "azuread_application_client_id" {
  value = azuread_application.application.client_id
}

output "azuread_application_id" {
  value = azuread_application.application.id
}

output "azuread_application_object_id" {
  value = azuread_application.application.object_id 
}

output "azuread_spn_object_id" {
  value = azuread_service_principal.spn.object_id
}

output "azuread_application_id_secret" {
  sensitive = true
  value = azuread_application_password.application.value
}

output "azuread_application_tenant_id" {
  value = data.azuread_client_config.current.tenant_id
}