provider "azurerm" {
  subscription_id = "d276ebc2-efd2-4b53-9eb4-304982e42f4b"
  version = "2.12.0"
  features {}
}
/*module "default_resource_tags" {
  source = "../../modules/tags"  
} 
locals {
  //  mandatory_tags = "${module.default_resource_tags.mandatory_tags}"
    resource_loaction = "${module.default_resource_tags}"
} */

 module "default_public_ip" {
     source = "../../modules/publicip"
     
     public_ip_name = var.public_ip_name
     resource_location = var.resource_location
     resource_group_name = var.resource_group_name
     allocation_method   = var.allocation_method
     sku = var.sku
 //  mandatory_tags = "${local.mandatory_tags}"
 }
 data "azurerm_subnet" "default_subnet" {
  name                 = var.bastion_subnet_name
  virtual_network_name = var.bastion_vnet_name
  resource_group_name  = var.bation_vnet_resource_group_name
}
 locals {
     public_ip = "${module.default_public_ip.id}"
 }

resource "azurerm_bastion_host" "generic_bastion_host" {
  name                = var.bastion_host_name
  location            = var.resource_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.default_subnet.id
    public_ip_address_id = module.default_public_ip.id
  }
}