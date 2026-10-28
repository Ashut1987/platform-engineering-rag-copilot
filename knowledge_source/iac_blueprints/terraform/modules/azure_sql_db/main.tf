resource "azurerm_sql_database" "example" {
  name                = var.sqldatabase_name
  resource_group_name = var.resource_group_name
  location            = var.resource_location
  server_name         = var.sql_server_name
  edition             = var.database_edition
  requested_service_objective_name = var.requested_service_objective_name
  }
