variable "infrastructure_name" {
  type = string
  description = "The prefix for the resources created in the specified Azure Resource Group."
}

variable "azure_vnets" {
  description = "The list of Azure Virtual networks."
}

variable "azure_vnets_peering" {
  description = "The list of peerings for Azure Virtual networks."
}

variable "azure_virtual_network_gateway_enabled" {
  type = bool
  description = "Use or not Azure Virtual Network gateway for remote access."
  default = false
}