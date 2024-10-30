# # The client ID for authenticating with Azure services
# variable "client_id" {
#   type        = string
#   description = "The client ID for authenticating with Azure services"
#   sensitive   = true
# }

# # The client secret for authenticating with Azure services
# variable "client_secret" {
#   type        = string
#   description = "The client secret for authenticating with Azure services"
#   sensitive   = true
# }

# # The tenant ID for your Azure subscription
# variable "tenant_id" {
#   type        = string
#   description = "The tenant ID for your Azure subscription"
#   sensitive   = true
# }

# The subscription ID for your Azure account
variable "subscription_id" {
  type        = string
  description = "The subscription ID for your Azure account"
  sensitive   = true
}

# The global Azure location where resources will be deployed
variable "global_location" {
  type        = string
  description = "The global Azure location where resources will be deployed"
}

# The name of the resource group for organizing related resources
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group for organizing related resources"
}

# The name of the virtual network to be created
variable "vnet_name" {
  type        = string
  description = "The name of the virtual network to be created"
}

# The name of the default subnet within the virtual network
variable "default_subnet_name" {
  type        = string
  description = "The name of the default subnet within the virtual network"
}

# The name of the subnet for Azure Kubernetes Service (AKS)
variable "aks_subnet_name" {
  type        = string
  description = "The name of the subnet for Azure Kubernetes Service (AKS)"
}

# The name of the public IP address to be created
variable "public_ip_name" {
  type        = string
  description = "The name of the public IP address to be created"
}

# The name of the Application Gateway to be created
variable "appgw_name" {
  type        = string
  description = "The name of the Application Gateway to be created"
}

# The name of the IP configuration for the Application Gateway
variable "appgw_ipconf_name" {
  type        = string
  description = "The name of the IP configuration for the Application Gateway"
}

# The name of the storage account to be created
variable "storageacc_name" {
  type        = string
  description = "The name of the storage account to be created"
}

# The name of the storage container to be created within the storage account
variable "storagecon_name" {
  type        = string
  description = "The name of the storage container to be created within the storage account"
}

# The name of the Azure Kubernetes Service (AKS) cluster
variable "aks_name" {
  type        = string
  description = "The name of the Azure Kubernetes Service (AKS) cluster"
}

# The storage class to be used for AKS
variable "aks_storage_class" {
  type        = string
  description = "The storage class to be used for AKS"
}

# The password for Graylog login
variable "graylog_password" {
  type        = string
  description = "The password for Graylog"
  default = "}9L4U86VEWg_V8=r]"
}

# A mapping of tags which should be assigned to all resources
variable "tags" {
  description = "A mapping of tags which should be assigned to all resources"
  type        = map(any)
  default     = {
    "Environment" = "test"
    "Company"     = "gordion"
  }
}
