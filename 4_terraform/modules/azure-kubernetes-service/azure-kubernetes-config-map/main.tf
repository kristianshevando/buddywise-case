resource "kubernetes_config_map" "config_map" {
  metadata {
    name        = var.kubernetes_config_map_name
    namespace   = var.kubernetes_config_map_namespace
    labels      = var.kubernetes_config_map_labels
    annotations = var.kubernetes_config_map_annotations
  }

  data        = var.kubernetes_config_map_data
  binary_data = var.kubernetes_config_map_binary_data
}