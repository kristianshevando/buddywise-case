variable "kubernetes_config_map_name" {
    type = string
}

variable "kubernetes_config_map_namespace" {
    type = string
}

variable "kubernetes_config_map_labels" {
    type = map(string)
    default = null
}

variable "kubernetes_config_map_annotations" {
    type = map(string)
    default = null
}

variable "kubernetes_config_map_data" {
    type = map(string)
    default = null
}

variable "kubernetes_config_map_binary_data" {
    type = map(string)
    default = null
}