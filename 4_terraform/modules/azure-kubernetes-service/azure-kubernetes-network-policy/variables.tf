variable "kubernetes_network_policy_namespace" {
    description = "Name of the k8s namespace."
    type = string
    default = null
}

variable "kubernetes_network_policy" {
    description = "List of network policy rules."
    default = null
}

variable "override_tfvars_value" {
    default = {}
}