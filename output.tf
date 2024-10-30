output "client_certificate" {
  value     = azurerm_kubernetes_cluster.caseaks.kube_config[0].client_certificate  # The client certificate for accessing the AKS cluster
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.caseaks.kube_config_raw  # The raw Kubernetes configuration for accessing the cluster

  sensitive = true
}
