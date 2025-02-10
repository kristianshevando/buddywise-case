variable "azure_resource_group_name" {   
    type = string
}

variable "azure_resource_group_location" {
    type = string
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}