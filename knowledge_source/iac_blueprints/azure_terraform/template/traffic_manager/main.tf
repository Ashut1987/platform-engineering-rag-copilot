resource "azurerm_resource_group" "services_resource_group" {
  name     = var.resource_group_name
  location = var.resource_location
  tags = local.common_tags
}
module "traffic_manager_profile" {
    source = "../../modules/traffic manager profile"

    count                        = length(var.traffic_manager_profile_name)
    traffic_manager_profile_name = var.traffic_manager_profile_name[count.index]
    resource_group_name          = azurerm_resource_group.services_resource_group.name
    traffic_routing_method       = var.traffic_routing_method
    traffic_manager_dns_config_relative_name = var.traffic_manager_dns_config_relative_name[count.index]
    protocol                     = var.protocol
    port                         = var.port
    path                         = var.path
    interval_in_seconds          = var.interval_in_seconds 
    timeout_in_seconds           = var.timeout_in_seconds
    tolerated_number_of_failures = var.tolerated_number_of_failures

    tags = local.common_tags
} 
module "traffic_manager_endpoint" {
    source = "../../modules/traffic manager endpoint"

    count                           = length(var.traffic_manager_profile_name)
    traffic_manager_endpoint_name   = var.traffic_manager_endpoint_name[count.index]
    resource_group_name             = azurerm_resource_group.services_resource_group.name
    traffic_manager_profile_name    = module.traffic_manager_profile[count.index].name
    traffic_manager_endpoint_target = var.traffic_manager_endpoint_target[count.index]
    traffic_manager_endpoint_type   = var.traffic_manager_endpoint_type
    traffic_manager_endpoint_priority = var.traffic_manager_endpoint_priority[count.index]
    traffic_manager_endpoint_location = var.traffic_manager_endpoint_location

    # tags = local.common_tags
}