data "azurerm_subnet" "primary_subnet" {
  name = var.nic_subnet_name
  virtual_network_name = var.nic_vnet_name
  resource_group_name = var.vnet_resource_group_name
}
resource "azurerm_network_interface" "generic_nic" {
  name     = "${var.nic_name}-nic"
  location = var.resource_location
  resource_group_name  = var.resource_group_name

  ip_configuration {
    name = var.nic_name
    subnet_id = data.azurerm_subnet.primary_subnet.id
    private_ip_address_allocation = var.nic_address_allocation
    private_ip_address = var.nic_ip_address
    primary = var.is_primary_nic
    public_ip_address_id = var.public_ip_address_id
  }
  
  
  tags = var.tags
}