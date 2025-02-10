variable "kubernetes_secret_name" {
    type = string
}

variable "kubernetes_secret_namespace" {
    type = string
}

variable "kubernetes_secret_labels" {
    type = map(string)
    default = null
}

variable "kubernetes_secret_annotations" {
    type = map(string)
    default = null
}

variable "kubernetes_secret_data" {
    type = map(string)
    sensitive = true
    default = null
}

variable "kubernetes_secret_binary_data" {
    type = map(string)
    sensitive = true
    default = null
}

variable "kubernetes_secret_type" {
    type = string
}

variable "kubernetes_secret_immutable" {
    type = bool
    default = false
}
