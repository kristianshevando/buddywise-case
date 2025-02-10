data "kubernetes_endpoints_v1" "endpoints" {
  metadata {
    name      = var.kubernetes_svc_name
    namespace = var.kubernetes_namespace_name
  }
}