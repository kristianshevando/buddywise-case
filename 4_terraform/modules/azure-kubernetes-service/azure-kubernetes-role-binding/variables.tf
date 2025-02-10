variable "kubernetes_role_binding_name" {
    type = string
}

variable "kubernetes_role_name" {
    type = string
}

variable "kubernetes_role_kind" {
    type = string
    default = "Role"
}

variable "kubernetes_subject_kind" {
    type = string
}

variable "kubernetes_subjects" {
    type = list(string)
}

variable "kubernetes_role_binding_namespace" {
    type = string
}