variable "azurerm_role_definition_name" {
    description = "Name of custom role definition."
    type = string
}

variable "azurerm_role_definition_description" {
    description = "Description of custom role."
    type = string
}

variable "permissions_actions" {
    description = "One or more Allowed Actions."
    type        = list(string)
    default     = [] 
}

variable "permissions_not_actions" {
    description = "One or more Disallowed Actions."
    type        = list(string)
    default     = [] 
}

variable "permissions_data_actions" {
    description = "One or more Allowed Data Actions."
    type        = list(string)
    default     = [] 
}

variable "permissions_not_data_actions" {
    description = "One or more Disallowed Data Actions."
    type        = list(string)
    default     = [] 
}

variable "assignable_scopes" {
    description = "One or more assignable scopes for this Role Definition."
    type        = list(string)
    default     = [] 
}