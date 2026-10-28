resource "azurerm_traffic_manager_endpoint" "example" {
  name                = var.traffic_manager_endpoint_name[count.index]
  count               = length(var.traffic_manager_endpoint_name)
  resource_group_name = var.resource_group_name
  profile_name        = var.traffic_manager_profile_name
  target              = var.traffic_manager_endpoint_target[count.index]
  type                = var.traffic_manager_endpoint_type
  priority            = var.traffic_manager_endpoint_priority[count.index]
  endpoint_location   = var.traffic_manager_endpoint_location  
  weight              = 100

}