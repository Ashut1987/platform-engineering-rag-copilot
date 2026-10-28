provider "azurerm" {
  subscription_id = "d276ebc2-efd2-4b53-9eb4-304982e42f4b"
  features {}
}
module "default_resource_group" {
    source = "../../modules/resource_group"

    resource_location = var.resource_location
    resource_group_name = var.resource_group_name
  //  mandatory_tags = "${local.mandatory_tags}"
}   