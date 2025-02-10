variable "azurerm_user_assigned_identity_name" {
    description = "The name of the user assigned identity."
    type = string
}

variable "azurerm_resource_group_name" {
    description = "The name of the resource group in which to create the user assigned identity."
    type = string
}

variable "location" {
    description = "The location/region where the user assigned identity is created."
    type = string
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}