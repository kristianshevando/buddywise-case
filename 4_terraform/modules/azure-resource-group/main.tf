resource "azurerm_resource_group" "azure_resource_group" {
  name     = var.azure_resource_group_name
  location = var.azure_resource_group_location

  tags = var.common_tags   

  lifecycle {
      prevent_destroy = false
  }
}