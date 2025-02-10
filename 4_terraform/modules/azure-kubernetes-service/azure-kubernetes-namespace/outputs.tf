output "k8s_namespace" {
  value = kubernetes_namespace.namespace.metadata[0].name
}