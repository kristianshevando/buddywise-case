variable "workspace_name" {
    description = "The name of the Azure Log Analytics Workspace."
    type        = string
}
variable "workspace_location" {
    description = "The region of the Azure Log Analytics Workspace."
    type        = string
}

variable "workspace_azure_resource_group_name" {
    description = "The resource group name for Azure Log Analytics Workspace."
    type        = string
}

variable "workspace_sku" {
	description = "Specifies the SKU of the Log Analytics Workspace."
	type        = string
}

variable "workspace_retention_in_days" {
	description = "The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
	type        = number
}

variable "common_tags" {
  type = map(string)
  description = "List of common tags"
  default = {}
}
