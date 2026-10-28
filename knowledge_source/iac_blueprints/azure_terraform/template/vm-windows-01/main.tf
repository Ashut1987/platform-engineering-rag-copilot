provider "azurerm" {
  features {}
 // subscription_id = "a40a7059-7960-4999-be7b-78f96c99166a"  
}
module "default_resource_group" {
    source = "../../modules/resource_group"

    resource_location = var.resource_location
    resource_group_name = var.resource_group_name
  //  mandatory_tags = "${local.mandatory_tags}"
}

module "default_public_ip" {
     source = "../../modules/publicip"
     
     public_ip_name = var.public_ip_name
     resource_location = var.resource_location
     resource_group_name = var.resource_group_name
     allocation_method   = var.allocation_method
     sku = var.sku
 //  mandatory_tags = "${local.mandatory_tags}"
 }

module "default_nic" {
      source = "../../modules/network_interface"
      
      resource_location = var.resource_location
      resource_group_name = var.resource_group_name

      nic_name = "${var.vm_host_name}-${var.nic_name}"
      nic_subnet_name = var.nic_subnet_name
      nic_vnet_name = var.nic_vnet_name
      nic_address_allocation = var.nic_address_allocation
      vnet_resource_group_name = var.vnet_resource_group_name

      //  mandatory_tags = "${local.mandatory_tags}"
}

module "vm_config" {
      source = "../../modules/vm_windows"

      resource_location     = var.resource_location
      resource_group_name   = var.resource_group_name
      //  mandatory_tags = "${local.mandatory_tags}"
      vm_zone = var.vm_zone

      nic_id = "${module.default_nic.id}"

      virtual_machine_name = "${var.vm_host_name}-vm-01"
      vm_host_name = var.vm_host_name
      vm_os_disk_size = var.vm_os_disk_size
      vm_data_disk_size = var.vm_data_disk_size
      vm_delete_data_disks = var.vm_delete_data_disks
      virtual_machine_size =var.virtual_machine_size
}