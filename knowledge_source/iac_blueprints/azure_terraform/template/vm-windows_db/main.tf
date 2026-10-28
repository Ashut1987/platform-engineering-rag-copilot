provider "azurerm" {
  version = "=2.0.0"
  features {}
  subscription_id = "a40a7059-7960-4999-be7b-78f96c99166a"  
}

locals {
    vm_os_disk_name = "os_disk"
    vm_data_disk_name = "data-disk"
}
# Create a resource group
module "../modules/resourceGroup" {
  resource_group_name     = "${var.resource_group_name}"
  resource_location = "${var.resource_location}"
}

# Create a public ip
mdoule "../modules/publicip" {
  azurerm_resource_group  = "${module.resourceGroup.resource_group_name}"
  resource_location          = "${module.resourceGroup.resource_location}"  
}
# Create a vnet
module "network" 
 source = "../source"
{

  azurerm_resource_group  = "${module.resourceGroup.resource_group_name}"
  resource_location       = "${module.resourceGroup.resource_location}"
  vnet_name               = "${var.vnet_name}"
  subnet_name             = "${var.subnet_name}"
}

# Create a nic
resource "azurerm_network_interface" "test" {
  name                = "vm-nic-01"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.test.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.test.id}"
  }
}
# Create a vm
resource "azurerm_virtual_machine" "test" {
  name                  = "${var.mandatory_prefix}-${var.virtual_machine_name}"
  location              = "${azurerm_resource_group.test.location}"
  resource_group_name   = "${azurerm_resource_group.test.name}"
  network_interface_ids = ["${azurerm_network_interface.test.id}"]
  vm_size               = "${var.virtual_machine_size}"

   delete_os_disk_on_termination = true
   delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "2019.0.20190115"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }
  os_profile_windows_config {
  }
}
module "database" {
  source = "source"
  
}
