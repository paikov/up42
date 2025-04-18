variable "ns" {
  description = "Default namespace to be used if not configured in Helm"
  type        = string
  default     = "up42-ns"
}

variable "service_name" {
  description = "Default s3www service name to be used if not configured in Helm"
  type        = string
  default     = "s3www-service"
}

variable "helm_chart_path" {
  description = "Path to Helm chart directory"
  type        = string
  default     = "../helm"
}

variable "release_name" {
  description = "Name of Helm release"
  type        = string
  default     = "up42-release"
}
