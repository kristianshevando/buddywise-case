variable "azure_private_dns_zones_ids" {
    description = "The ids of private DNS zone."
    type = string
}

variable "resource_group_name" {
    description = "Private DNS zone resource group name."
    type = string
}

variable "virtual_network_id" {
    description = "Azure virtual network id."
    type = string
}

variable "virtual_network_link_name" {
    description = "Azure virtual network link name."
    type = string
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}