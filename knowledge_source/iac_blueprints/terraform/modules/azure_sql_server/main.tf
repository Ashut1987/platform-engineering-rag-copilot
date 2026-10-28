resource "azurerm_sql_server" "example" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.resource_location
  version                      = var.sql_version
  administrator_login          = var.sql_user_id
  administrator_login_password = var.sql_password
  
  tags = var.tags
}