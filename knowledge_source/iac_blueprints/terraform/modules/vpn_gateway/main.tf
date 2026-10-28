provider "azurerm" {
    features {}
}
resource "azurerm_virtual_wan" "example" {
  name                = "example-vwan"
  resource_group_name = var.resource_group_name
  location            = var.resource_location
}

resource "azurerm_virtual_hub" "example" {
  name                = "example-hub"
  resource_group_name = var.resource_group_name
  location            = var.resource_location
  virtual_wan_id      = azurerm_virtual_wan.example.id
  address_prefix      = "10.0.1.0/24"
}

resource "azurerm_vpn_gateway" "example" {
  name                = "example-vpng"
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  virtual_hub_id      = azurerm_virtual_hub.example.id
}