variable "azuread_federated_identity_parent_id" {
    type = string
}

variable "azuread_federated_identity_name" {
    type = string
}

variable "azuread_federated_identity_resource_group_name" {
    type = string
}

variable "azuread_federated_identity_audience" {
    type = list(string)
}

variable "azuread_federated_identity_issuer" {
    type = string
}

variable "azuread_federated_identity_subject" {
    type = string
}