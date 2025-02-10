resource "kubernetes_storage_class" "storage_class" {
  metadata {
    name = var.kubernetes_storage_class_name
  }
  storage_provisioner    = var.kubernetes_storage_class_provisioner
  reclaim_policy         = var.kubernetes_storage_class_reclaim_policy
  parameters 	           = var.kubernetes_storage_class_parameters
  mount_options          = var.kubernetes_storage_class_mount_options
  volume_binding_mode    = var.kubernetes_storage_class_volume_binding_mode
  allow_volume_expansion = var.kubernetes_storage_class_allow_volume_expansion
}