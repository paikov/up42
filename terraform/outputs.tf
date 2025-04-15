output "application_url" {
  description = "URL to access the s3www application (localhost for Kubernetes on Docker)"
  value       = local.application_url
}

output "deployed_namespace" {
  description = "Namespace where the application was deployed."
  value       = local.chart_namespace
}
