variable "location" {
    description = "The region of Virtual network gateway."
    type = string
}

variable "azure_resource_group_name" {
    description = "Virtual network gateway resource group name."
    type = string
}

variable "azurerm_virtual_network_gateway_name" {
    type = string
    description = "Name of virtual network gateway."
}

variable "public_ip_address_id" {
    type = string
    description = "Public interface id for virtual network gateway."
}

variable "azure_subnet_id" {
    type = string
    description = "Virtual network subnet id for virtual network gateway."
}

variable "gateway_type" {
    type    = string
    default = "Vpn"
}

variable "vpn_type" {
    type    = string
    default = "RouteBased"
}

variable "active_active" {
    type    = bool
    default = false
}

variable "enable_bgp" {
    type    = bool
    default = false
}

variable "sku" {
    type    = string
    default = "VpnGw1"
}

variable "generation" {
    type    = string
    default = "Generation1"
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}