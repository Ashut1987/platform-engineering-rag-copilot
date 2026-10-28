
data "azurerm_subnet" "primary_subnet" {
  name = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name = var.vnet_resource_group_name
}

locals {
  vm_os_disk_name = "os-disk"
}

data "azurerm_shared_image" "share_custom_image" {
  name = var.shared_image_name
  gallery_name = var.shared_gallery_name
  resource_group_name = var.shared_gallery_resource_group
}
resource "azurerm_network_interface" "primary_nic" {
  name = var.nic_name
  location = var.resource_location
  resource_group_name = var.resource_group_name

  network_security_group_id = var.nic_nsg_id
  ip_configuration {
    name = "vm-nic-subnet-01"
    subnet_id = data.azurerm_subnet.primary_subnet.id
    private_ip_address_allocation = var.nic_address_allocation
    private_ip_address = var.nic_private_ip_address
    primary = true
  }
  
  tags = var.tags
}

resource "azurerm_virtual_machine" "generic_linux_vm" {
  name = var.vm_name
  location = var.resource_location
  resource_group_name = var.resource_group_name

  network_interface_ids = [azurerm_network_interface.primary_nic.id]
  vm_size = var.virtual_machine_size
  zones = [var.vm_zone]

  delete_os_disk_on_termination = "${var.vm_delete_os_disk}"
  delete_data_disks_on_termination = "${var.vm_delete_data_disks}"

  storage_image_reference {
    id = "${data.azurerm_shared_image.share_custom_image.id}"
    
    //version = "${var.vm_sku_version}"
  }  
  plan {
    name = "${var.vm_sku}"
    publisher = "${var.vm_publisher}"
    product = "${var.vm_offer}"
  }
  storage_os_disk {
    name              = "${var.mandatory_prefix}-${var.resource_location}-${var.virtual_machine_name}-${local.vm_os_disk_name}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb = "${var.vm_os_disk_size}"
  }

  os_profile {
    computer_name  = "${var.mandatory_prefix}-${var.resource_location}-${var.virtual_machine_name}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }
  os_profile_linux_config {
      disable_password_authentication = false
  }
  tags = "${var.mandatory_tags}"

  depends_on = [
    "azurerm_network_interface.primary_nic"
  ]
}