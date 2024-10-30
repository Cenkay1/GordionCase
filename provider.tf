terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"  # Azure Resource Manager provider
      version = ">= 4.1.0, < 5.0.0"   # Azure RM provider version constraints
    }
    helm = {
      source  = "hashicorp/helm"      # Helm provider
      version = ">= 2.0.0, < 3.0.0"    # Helm provider version constraints
    }
  }
}

# Configure with az login
provider "azurerm" {
  features {}                        # Enable default features for the Azure RM provider
  # client_id       = var.client_id  # Uncomment to use client ID for authentication
  # client_secret   = var.client_secret  # Uncomment to use client secret for authentication
  # tenant_id       = var.tenant_id  # Uncomment to use tenant ID for authentication
  subscription_id = var.subscription_id  # Specify the Azure subscription ID
}

provider "helm" {
   kubernetes {
    host              = azurerm_kubernetes_cluster.caseaks.kube_config[0].host  # Kubernetes cluster host
    client_certificate = base64decode(                                         # Decode the client certificate
      azurerm_kubernetes_cluster.caseaks.kube_config[0].client_certificate,
    )
    client_key = base64decode(                                                # Decode the client key
      azurerm_kubernetes_cluster.caseaks.kube_config[0].client_key
    )
    cluster_ca_certificate = base64decode(                                    # Decode the cluster CA certificate
      azurerm_kubernetes_cluster.caseaks.kube_config[0].cluster_ca_certificate,
    )
  } 
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.caseaks.kube_config[0].host  # Kubernetes cluster host
  client_certificate = base64decode(                                               # Decode the client certificate
    azurerm_kubernetes_cluster.caseaks.kube_config[0].client_certificate,
  )
  client_key = base64decode(                                                      # Decode the client key
    azurerm_kubernetes_cluster.caseaks.kube_config[0].client_key
  )
  cluster_ca_certificate = base64decode(                                          # Decode the cluster CA certificate
    azurerm_kubernetes_cluster.caseaks.kube_config[0].cluster_ca_certificate,
  )
}
