resource "azurerm_traffic_manager_profile" "example" {
  name                = var.traffic_manager_profile_name
  resource_group_name = var.resource_group_name

  traffic_routing_method = var.traffic_routing_method
  # count = length(var.traffic_manager_profile_name)
  dns_config {
    relative_name = var.traffic_manager_dns_config_relative_name
    ttl           = 100
  }

  monitor_config {
    protocol                     = var.protocol
    port                         = var.port
    path                         = var.path
    interval_in_seconds          = var.interval_in_seconds 
    timeout_in_seconds           = var.timeout_in_seconds
    tolerated_number_of_failures = var.tolerated_number_of_failures
  }
  
  tags = var.tags
}