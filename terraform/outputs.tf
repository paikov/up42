output "application_url" {
  description = "URL to access the s3www application (localhost for Kubernetes on Docker)"
  value       = "http://${data.kubernetes_service.s3www_service.status[0].load_balancer[0].ingress[0].hostname}"
}

output "deployed_namespace" {
  description = "Namespace where the application was deployed."
  value       = local.chart_namespace
}
