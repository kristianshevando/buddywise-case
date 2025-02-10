variable "kubernetes_storage_class_name" {
    type = string
}

variable "kubernetes_storage_class_provisioner" {
    type = string
}

variable "kubernetes_storage_class_reclaim_policy" {
    type = string
    default = null
}

variable "kubernetes_storage_class_volume_binding_mode" {
    type = string
    default = null
}

variable "kubernetes_storage_class_allow_volume_expansion" {
    type = bool
    default = true
}

variable "kubernetes_storage_class_parameters" {
    type = map(string)
    default = null
}

variable "kubernetes_storage_class_mount_options" {
    type = list(string)
    default = null
}