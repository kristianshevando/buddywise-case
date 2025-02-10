variable "SPN_CLIENT_ID" {
  type      = string
  default   = null
}

variable "SPN_CLIENT_SECRET" {
  type      = string
  sensitive = true
  default   = null
}

variable "TENANT_ID" {
  type      = string
  default   = null
}

variable "SUBSCRIPTION_ID" {
  type      = string
  default   = null
}

variable "INFRASTRUCTURE_NAME" {
  type        = string
  description = "The name for the resources created in the specified Azure Resource Group"
  validation {
    condition     = length(var.INFRASTRUCTURE_NAME) <= 14
    error_message = "Infrastructure name should be no more 14 character long."
  }
}
variable "PREFIX" {
  type        = string
  description = "The prefix for the resources name."
}

variable "SUFFIX" {
  type        = string
  description = "The suffix for the resources name."
}

variable "LOCATION" {
  type        = string
  description = "The location for the deployment"
}

variable "AUTOMATED_DESTROY" {
  type        = string
  description = "Enable destroy of infrastructure from the pipeline."
  default     = "disabled"
}

variable "TERRAFORM_CODE_PACKAGE_NUMBER" {
  type        = string
  description = "Version of Terraform IaC package."
}

variable "infrastructure_code_version" {
  type        = string
  description = "Version of IaC code. Connected to Managed Services repo tags."
  default     = null
}

variable "azurerm_k8s_clusters" {
  description = "List of k8s clusters configuration data."
}

variable "azure_sa_firewall_enabled" {
  type = bool
  description = "Create default deny rule in Azure Storage Account firewall."
  default = true
}

variable "azurerm_key_vault_network_acls_default_action" {
  description = "Create default deny rule in Azure Key Vault firewall."
  type = string
  default = "Deny"
}