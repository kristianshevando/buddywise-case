variable "infrastructure_name" {
  type        = string
  description = "The infrastructure name for the resources created in the specified Azure Resource Group"
}

variable "infrastructure_prefix" {
  type        = string
  description = "The infrastructure prefix for the resources created in the specified Azure Resource Group"
}

variable "azure_virtual_network_gateway_enabled" {
  type        = bool
  default     = false
  description = "Enable or disable deploy for Azure VPN GW."
}

variable "azure_virtual_network_gateway_vnet_address_space" {
  type        = list(string)
  description = "Address space for private remote access infrastructure."
}

variable "azure_virtual_network_gateway_public_ip_sku" {
  type        = string
  description = "SKU of public ip for private remote access infrastructure."
}

variable "azure_virtual_network_gateway_public_ip_allocation_method" {
  type        = string
  description = "Allocation method of VPN Gateway public IP."
}

variable "azure_virtual_network_gateway_subnet_additional_bitmask" {
    description = "Additional bitmask to calculate size of Virtual Network subnet."
    type = number
    default = 4
}

variable "azure_virtual_network_private_endpoint_subnet_additional_bitmask" {
    description = "Additional bitmask to calculate size of Virtual Network subnet."
    type = number
    default = 1
}

variable "azure_virtual_network_gateway_availability_zones" {
    description = "The availability zone to allocate the Public IP in."
    type        = list(string)
    default     = null
}

variable "azure_virtual_network_gateway_type" {
    type = string
    description = "The type of the Virtual Network Gateway."
}

variable "azure_virtual_network_gateway_vpn_type" {
    type = string
    description = "The routing type of the Virtual Network Gateway."
}

variable "azure_virtual_network_gateway_active_active" {
    type = bool
    description = "If true, an active-active Virtual Network Gateway will be created."
}

variable "azure_virtual_network_gateway_enable_bgp" {
    type = bool
    description = "If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway."
}

variable "azure_virtual_network_gateway_sku" {
    type = string
    description = "Configuration of the size and capacity of the virtual network gateway."
}

variable "azure_virtual_network_gateway_generation" {
    type = string
    description = "The Generation of the Virtual Network gateway."
}

variable "azure_virtual_network_gateway_vnet_dns_servers" {
    type = list(string)
    description = "Azure Virtual Network custom DNS server address."
}

variable "azure_virtual_network_gateway_region" {
    type = string
    description = "Private remote access infrastructure region."
}

variable "azure_virtual_network_gateway_region_index" {
    type = string
    description = "Private remote access infrastructure region index."
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}

variable "azure_key_vault_id" {
    type = string
    description = "Azure Key Vault ID to store configuration data."
}