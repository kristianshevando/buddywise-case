variable "private_endpoint_name" {
    description = "The name of Azure Private Endpoint."
    type = string
}

variable "location" {
    description = "The region of Azure Private Endpoint."
    type = string
}

variable "resource_group_name" {
    description = "Azure Private Endpoint resource group name."
    type = string
}

variable "azurerm_private_endpoint_subnet_id" {
    description = "Azure Private Endpoint subnet id."
    type = string
}

variable "azurerm_resource_id" {
    description = "Azure Private Endpoint resource id."
    type = string
}

variable "subresource_names" {
    description = "Azure Private Endpoint subresource names."
    type = string
    default = null
}

variable "private_service_connection_auto_approvement_disabled" {
    description = "Does the Private Endpoint require Manual Approval from the remote resource owner."
    type = bool
    default = false
}

variable "private_service_connection_approvement_request_message" {
    description = "Does the Private Endpoint require Manual Approval from the remote resource owner."
    type = string
    default = "none"
}

variable "azurerm_private_dns_zone_id" {
    description = "Azure Private DNS zone ID to create appropriate A records."
    type = list(string)
    default = []
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}