output "azuread_group_object_id" {
  value = azuread_group.group.object_id
}

output "azuread_group_display_name" {
  value = azuread_group.group.display_name
}

output "azuread_groups" {
  value = {
    display_name = azuread_group.group.display_name
    object_id = azuread_group.group.object_id
  }
}