resource "azurerm_resource_group" "services_resource_group" {
  name     = var.resource_group_name
  location = var.resource_location
  tags = var.tags
}