variable "azure_vnet_name" {   
    type = string
}

variable "azure_resource_group_name" {
    type = string
}

variable "azure_vnet_address_space" {
    type = list(string)
}

variable "innovator_components" {
}

variable "azure_key_vault_id" {
    type = string
}

variable "infrastructure_name" {
    type = string
}

variable "infrastructure_prefix" {
    type = string
}

variable "azure_vnet_location" {
    type = string
}

variable "default_network_ports_to_allow" {
    type = string
    default = "*"
}

variable "default_source_address_prefix" {
    type = string
    default = "*"
}

variable "default_rule_action" {
    type = string
    default = "Deny"
}

variable "inbound_default_deny_rule" {
    type    = bool
    default = true
}

variable "outbound_default_deny_rule" {
    type    = bool
    default = true
}

variable "address_prefixes" {
    type    = list(string)
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}