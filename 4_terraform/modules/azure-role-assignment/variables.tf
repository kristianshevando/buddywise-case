variable "azurerm_role_assignment_scope" {
    description = "The scope at which the Role Assignment applies to."
    type = string
}

variable "role_definition_name" {
    description = "The name of a built-in Role."
    type = string
    default = null
}

variable "role_definition_resource_id" {
    description = "The id of a built-in Role."
    type = string
    default = null
}

variable "azurerm_principal_id" {
    description = "The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to."
    type = string
}