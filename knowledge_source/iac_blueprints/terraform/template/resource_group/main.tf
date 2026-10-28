provider "azurerm" {
  features {}

}
module "rg" {
  source = "../../modules/resource_group"

  resource_group_name = var.rg_name
  resource_location = var.location
  
}
