variable "kubernetes_cluster_role_binding_name" {
    type = string
}

variable "kubernetes_cluster_role_name" {
    type = string
}

variable "kubernetes_role_kind" {
    type = string
    default = "ClusterRole"
}

variable "kubernetes_cluster_subject_kind" {
    type = string
}

variable "kubernetes_cluster_subject_namespace" {
    type = string
    default = null
}

variable "kubernetes_cluster_subjects" {
    type = list(string)
}