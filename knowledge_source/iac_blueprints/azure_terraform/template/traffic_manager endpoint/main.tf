resource "azurerm_resource_group" "services_resource_group" {
  name     = var.resource_group_name
  location = var.resource_location
  tags     = local.common_tags
}

module "traffic_manager_endpoint" {
    source = "../../modules/traffic manager endpoint"

    count                             = length(var.traffic_manager_endpoint_name)
    traffic_manager_endpoint_name     = var.traffic_manager_endpoint_name[count.index]
    resource_group_name               = azurerm_resource_group.services_resource_group.name
    traffic_manager_profile_name      = var.traffic_manager_profile_name
    traffic_manager_endpoint_target   = var.traffic_manager_endpoint_target
    traffic_manager_endpoint_type     = var.traffic_manager_endpoint_type
    traffic_manager_endpoint_priority = var.traffic_manager_endpoint_priority
    traffic_manager_endpoint_location = var.traffic_manager_endpoint_location

}