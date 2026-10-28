locals {
    vm_os_disk_name = "os_disk"
    vm_data_disk_name = "data-disk"
}
resource "azurerm_virtual_machine" "generic_windows_vm" {
  name                  = var.virtual_machine_name
  location              = var.resource_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [var.nic_id]
  vm_size               = var.virtual_machine_size
  zones                 = [var.vm_zone]

   delete_os_disk_on_termination = true
   delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "2019.0.20190115"
  }
  storage_os_disk {
    name              = "${var.virtual_machine_name}-${local.vm_os_disk_name}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb = var.vm_os_disk_size
    managed_disk_type = "Standard_LRS"
    os_type = "Windows"
  }
  storage_data_disk {
    name              = "${var.virtual_machine_name}-${local.vm_data_disk_name}"
    create_option     = "Empty"
    disk_size_gb      = var.vm_data_disk_size
    lun               = 1
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vm_host_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_windows_config {
  }
  tags = var.tags
}