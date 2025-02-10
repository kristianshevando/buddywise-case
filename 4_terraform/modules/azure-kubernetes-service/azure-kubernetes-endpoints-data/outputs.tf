output "kubernetes_svc_endpoints" {
  value = data.kubernetes_endpoints_v1.endpoints.subset
}