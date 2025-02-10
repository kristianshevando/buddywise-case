resource "azuread_group_member" "group_membership" {
  group_object_id  = var.azuread_group_object_id
  member_object_id = var.azuread_member_object_id
}