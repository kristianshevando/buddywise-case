variable "azuread_application_display_name" {
    description = "The display name for the application."
    type = string
}

variable "override_special" {
    type = string
    default = "@$#!"
}

variable "secret_length" {
    type = number
    default = 32
}