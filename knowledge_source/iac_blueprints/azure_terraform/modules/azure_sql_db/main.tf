provider "azurerm" {
  version = "=2.0.0"
  features {}
  subscription_id = "a40a7059-7960-4999-be7b-78f96c99166a"  
}

# Create a vnet
resource "azurerm_virtual_network" "test" {
  name                = "${var.vnet_name}"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.resource_location}"
  resource_group_name = "${var.resource_group_name}"
}
# Create a subnet
resource "azurerm_subnet" "test" {
  name                 = "${var.subnet_name}"
  resource_group_name = "${var.resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "10.0.2.0/24"
}