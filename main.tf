resource "azurerm_resource_group" "caserg01" {
  name     = var.resource_group_name
  location = var.global_location
  tags = var.tags
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "casevnet01" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.caserg01.name
  location            = var.global_location
  address_space       = ["10.0.0.0/16"]
  tags = var.tags
}

resource "azurerm_subnet" "casedefaultsn" {
  name                 = var.default_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.casevnet01.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "caseakssn" {
  name                 = var.aks_subnet_name
  resource_group_name  = azurerm_resource_group.caserg01.name
  virtual_network_name = azurerm_virtual_network.casevnet01.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_kubernetes_cluster" "caseaks" {
  name                = var.aks_name
  location            = var.global_location
  resource_group_name = azurerm_resource_group.caserg01.name
  dns_prefix          = var.aks_name
  kubernetes_version  = "1.28.3"
  role_based_access_control_enabled = true
  azure_policy_enabled = true

  default_node_pool {
    name       = "systempool"
    node_count = 3
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id  = azurerm_subnet.caseakssn.id
  }

network_profile {
  network_plugin    = "kubenet"
  service_cidr      = "10.0.1.0/24"
  dns_service_ip    = "10.0.1.10"     
}

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Retrieve the resource group for the infrastructure created by the AKS cluster.
data "azurerm_resource_group" "aks_infra_rg" {
  name = "${azurerm_kubernetes_cluster.caseaks.node_resource_group}"
}

# Retrieve the Azure Load Balancer associated with the AKS cluster.
data "azurerm_lb" "aks_lb" {
  name                = "kubernetes"  # The name of the Load Balancer. This is typically "kubernetes" for AKS.
  resource_group_name = data.azurerm_resource_group.aks_infra_rg.name  # Reference the resource group containing the Load Balancer.
}

# Retrieve the public IP address associated with the Load Balancer's frontend configuration.
data "azurerm_public_ip" "aks_lb_public_ip" {
  # Extract the name of the public IP from the Load Balancer's frontend IP configuration.
  name                = split("/", data.azurerm_lb.aks_lb.frontend_ip_configuration[0].public_ip_address_id)[8]
  resource_group_name = data.azurerm_resource_group.aks_infra_rg.name  # Reference the resource group containing the public IP.
}


resource "azurerm_public_ip" "casepublicip01" {
  name                = var.public_ip_name
  resource_group_name = azurerm_resource_group.caserg01.name
  location            = var.global_location
  allocation_method   = "Static"
  tags = var.tags
}

resource "azurerm_application_gateway" "caseappgw" {
  name                = var.appgw_name
  resource_group_name = azurerm_resource_group.caserg01.name
  location            = var.global_location
  tags = var.tags
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = var.appgw_ipconf_name
    subnet_id = azurerm_subnet.casedefaultsn.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 9000
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.casepublicip01.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
    ip_addresses = [data.azurerm_public_ip.aks_lb_public_ip.ip_address]
  }
  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
    
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 10
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}

resource "azurerm_storage_account" "example" {
  name                     = var.aks_storage_class # Must be unique
  resource_group_name      = azurerm_resource_group.caserg01.name
  location                 = var.global_location
  account_tier            = "Standard"
  account_replication_type = "LRS" 
}

resource "kubernetes_storage_class" "graylogstorageclass" {
  metadata {
    name = var.aks_storage_class
  }
  storage_provisioner  = "kubernetes.io/azure-disk"
  volume_binding_mode  = "WaitForFirstConsumer"
  reclaim_policy       = "Delete"
  allow_volume_expansion = true
  parameters = {
    skuName = "Standard_LRS"
  }
}

resource "helm_release" "graylog" {
  name       = "graylog-release"
  chart      = "helm-chart"
  cleanup_on_fail = true
  create_namespace = true
  namespace  = "graylog"
  version = 1.0
  values = [file("values.yaml")]
  set {
    name  = "graylog.rootPassword"
    value = var.graylog_password
  }
  set {
    name = "graylog.persistence.storageClass"
    value = var.aks_storage_class
  }
}
