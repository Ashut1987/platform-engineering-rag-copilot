resource "azurerm_resource_group" "services_resource_group" {
  name     = var.resource_group_name
  location = var.resource_location
  tags = var.tags
}
locals {
  resource_group_created_name = "${azurerm_resource_group.services_resource_group.name}"
}