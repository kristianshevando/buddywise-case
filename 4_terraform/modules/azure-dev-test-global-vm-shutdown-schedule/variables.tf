variable "location" {
    description = "The region of Azure virtual machine."
    type = string
}

variable "azurerm_virtual_machine_id" {
    description = "The resource IDs of the target VMs."
    type = string
}

variable "azurerm_vm_auto_shutdown_utc_time" {
    description = "Time to shutdown (UTC)."
    type = string
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}