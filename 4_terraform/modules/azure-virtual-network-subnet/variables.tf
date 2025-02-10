variable "azure_vnet_name" {   
    type = string
}

variable "azure_resource_group_name" {
    type = string
}

variable "azure_subnet_name" {
    type = string
}

variable "azure_subnet_address_prefix" {
    type = string
}

variable "azure_key_vault_id" {
    type = string
}

variable "enforce_private_link_endpoint_network_policies" {
    type    = bool
    default = false
}

variable "create_azure_network_security_group" {
    type    = bool
    default = true
}

variable "azure_vnet_location" {
    type = string
}

variable "azure_nsg_rules" {
    default = []
}

variable "inbound_default_deny_rule" {
    type    = bool
    default = true
}

variable "outbound_default_deny_rule" {
    type    = bool
    default = true
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}