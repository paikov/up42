terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.36.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.17.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

locals {
  # Dynamically get namespace name from Helm code, maintaining a single source of truth
  chart_values_path  = "${path.module}/${var.helm_chart_path}/values.yaml"
  chart_values       = yamldecode(file(local.chart_values_path))
  chart_namespace    = try(local.chart_values.namespace, "${var.ns}")
  chart_service_name = try(local.chart_values.service.name, "${var.service_name}")
}

resource "helm_release" "app_release" {
  name             = var.release_name
  chart            = var.helm_chart_path
  namespace        = local.chart_namespace
  wait             = true
  timeout          = 300
  create_namespace = true
}

data "kubernetes_service" "s3www_service" {
  metadata {
    name      = local.chart_service_name
    namespace = local.chart_namespace
  }
  depends_on = [helm_release.app_release]
}
