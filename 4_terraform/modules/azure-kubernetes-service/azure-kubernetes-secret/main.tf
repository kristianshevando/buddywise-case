resource "kubernetes_secret" "secret" {
  metadata {
    name        = var.kubernetes_secret_name
    namespace   = var.kubernetes_secret_namespace
    labels      = var.kubernetes_secret_labels
    annotations = var.kubernetes_secret_annotations
  }

  data        = var.kubernetes_secret_data
  binary_data = var.kubernetes_secret_binary_data
  type        = var.kubernetes_secret_type
  immutable   = var.kubernetes_secret_immutable
}