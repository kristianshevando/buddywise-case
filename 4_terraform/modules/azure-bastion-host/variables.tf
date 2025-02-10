variable "location" {
    description = "The region of public ip."
    type = string
}

variable "bastion_host_name" {
    description = "The name of the Bastion host."
    type = string
}

variable "azure_resource_group_name" {
    description = "Bastion resource group name."
    type = string
}

variable "azure_subnet_id" {
    type = string
    description = "Subnet id for Azure Bastion host."
}

variable "public_ip_address_id" {
    type = string
    description = "Public ip id for Azure Bastion host."
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}