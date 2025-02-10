variable "k8s_namespace_name" {
    type = string
}

variable "k8s_namespace_labels" {
    type    = map(string)
    default = null
}

variable "k8s_namespace_annotations" {
    type    = map(string)
    default = null
}