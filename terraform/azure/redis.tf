locals {
  environments_set = toset(["dev", "stage", "prod"])
}

resource "azurerm_redis_cache" "automation" {
  for_each                      = local.environments_set
  name                          = "automation-${var.username}-${each.value}"
  location                      = azurerm_resource_group.automation.location
  resource_group_name           = azurerm_resource_group.automation.name
  capacity                      = 0
  family                        = "C"
  sku_name                      = "Basic"
  non_ssl_port_enabled          = false
  minimum_tls_version           = "1.2"
  tags                          = var.tags
  public_network_access_enabled = false
  redis_configuration {
    maxmemory_policy = "allkeys-lru"
  }
}

# output "redis" {
#   value = { for env, redis in azurerm_redis_cache.automation : env => redis.hostname }
# }

output "redis_dev" {
  value = azurerm_redis_cache.automation["dev"].hostname
}

output "redis_stage" {
  value = azurerm_redis_cache.automation["stage"].hostname
}

output "redis_prod" {
  value = azurerm_redis_cache.automation["prod"].hostname
}