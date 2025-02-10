output "k8s_storage_class_name" {
  value = kubernetes_storage_class.storage_class.metadata[0].name
}