locals {
  aks_service_cidr = cidrsubnet(one(azurerm_virtual_network.automation.address_space), 8, 10)
}

resource "azurerm_kubernetes_cluster" "automation" {
  name                      = "automation-${var.username}"
  location                  = azurerm_resource_group.automation.location
  resource_group_name       = azurerm_resource_group.automation.name
  dns_prefix                = "automationaks1"
  automatic_upgrade_channel = "patch"
  kubernetes_version        = "1.30"
  tags                      = var.tags

  http_application_routing_enabled = true

  default_node_pool {
    name                 = "automation"
    node_count           = 2
    min_count            = 1
    max_count            = 5
    vm_size              = "Standard_B2s"
    zones                = ["1", "2", "3"]
    auto_scaling_enabled = true
    vnet_subnet_id       = azurerm_subnet.internal_aks.id
    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  identity {
    type = "SystemAssigned"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = local.aks_service_cidr
    dns_service_ip = cidrhost(local.aks_service_cidr, 10)
  }

  web_app_routing {
    dns_zone_ids = []
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.automation.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.automation.kube_config_raw

  sensitive = true
}



# -----
# resource "azurerm_kubernetes_cluster_node_pool" "default" {
#   name                = "default"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
#   vm_size             = "Standard_DS2_v2"
#   node_count          = 2
#   min_count           = 1
#   max_count           = 5
#   enable_auto_scaling = true

#   vnet_subnet_id      = azurerm_subnet.aks_subnet.id
#   orchestrator_version = azurerm_kubernetes_cluster.aks.kubernetes_version
# }

# resource "azurerm_kubernetes_cluster" "aks" {
#   name                = "aks-cluster"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   dns_prefix          = "akscluster"
#   kubernetes_version  = "1.27.0"

#   default_node_pool {
#     name           = "nodepool1"
#     vm_size        = "Standard_DS2_v2"
#     node_count     = 2
#     vnet_subnet_id = azurerm_subnet.aks_subnet.id
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   network_profile {
#     network_plugin    = "azure"
#     load_balancer_sku = "standard"
#   }
# }