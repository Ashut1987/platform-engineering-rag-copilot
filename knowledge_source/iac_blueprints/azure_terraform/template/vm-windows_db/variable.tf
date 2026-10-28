/*
variable "mandatory_tags" {
    type = "map"
    description = "Provide mandatory tags"
    value = ""
}
*/
variable "mandatory_prefix" {
    description = "Provide mandatory prefix"
    default = "tf-test"
}

variable "resource_group_name" {
    description = "Provide rg name without prefix"
    default = "windows-test-vm-01"
}
variable "resource_location" {
    default = "eastus2"
    description = "Provide rg location"
}
/*variable "nic_id" {
    description = "Id for network interface card"
    value = ""
}
*/
variable "virtual_machine_name" {
    description = "Virtual Machine name"
    default = "aztfvmtest01"
}
/*
variable "vm_zone" {
    description = "Zone where VM is located"
    value = ""
}
*/
variable "virtual_machine_size" {
    description = "Provide the VM sku"
    default = "Standard_D2_v2"
}
/*
variable "vm_publisher" {
    description = "Publisher for VM image"
    value = ""
}
variable "vm_offer" {
    description = "Publisher OS offer for the VM"
    value = ""
}
variable "vm_sku" {
    description = "SKU for VM"
    value = ""
}
variable "vm_sku_version" {
    description = "Version to select for the VM SKU"
    value = "latest"
}
variable "vm_delete_os_disk" {
    description = "value should be true or false"
    default = "true"
    value = ""
}
variable "vm_delete_data_disks" {
    description = "value should be true or false"
    default = "true"
    value = ""
}
*/
variable "admin_username" {
    description = "Username to login to VM"
    default = "DevOps"
}
variable "admin_password" {
    description = "password to login to VM"
    default = "DevOps@12345"
}
/*variable "vm_time_zone" {
    description = "Timezone to be set for VM"
    default = "Eastern Standard Time"
}
*/

