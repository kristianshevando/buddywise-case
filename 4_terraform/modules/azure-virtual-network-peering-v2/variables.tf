variable "azurerm_virtual_network_peering_name" {
  type = string
  description = "The name of the virtual network peering."
}

variable "azurerm_resource_group_name" {
  type = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "azurerm_virtual_network_name" {
  type = string
  description = "The name of the virtual network."
}

variable "azurerm_remote_virtual_network_id" {
  type = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "azurerm_allow_gateway_transit" {
  type = bool
  description = "Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network."
}

variable "azurerm_use_remote_gateways" {
  type = bool
  description = "Controls if remote gateways can be used on the local virtual network."
}

variable "azurerm_allow_virtual_network_access" {
  type = bool
  description = "Controls if remote gateways can be used on the local virtual network."
  default = true
}

variable "azurerm_allow_forwarded_traffic" {
  type = bool
  description = "Controls if forwarded traffic from VMs in the remote virtual network is allowed."
  default = false
}