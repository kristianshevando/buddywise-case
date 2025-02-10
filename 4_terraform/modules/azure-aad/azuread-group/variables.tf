variable "azuread_group_display_name" {
    type = string
}

variable "azuread_group_owners" {
    type = list(string)
}

variable "azuread_group_prevent_duplicate_names" {
    type = bool
}

variable "azuread_group_security_enabled" {
    type = bool
}