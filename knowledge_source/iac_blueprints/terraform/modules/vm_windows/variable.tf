variable "resource_group_name" {
    description = "Provide rg name without prefix"
}
variable "resource_location" {
    description = "Provide rg location"
}
variable "nic_id" {
    description = "Id of the NIC"
}
variable "virtual_machine_name"{
    description = "Please provide Virtual machine name"
}
variable "vm_host_name" {
    description = "Host name for the VM"
}
variable "vm_zone" {
    type = string
    description = "Zone where the VM is located"
}
variable "virtual_machine_size" {
    type = string
    description = "The image sku to be used to create the VM"
}
variable "vm_os_disk_size" {
    type = string
    description = "Size of the managed OS disk for the VM"
}
variable "vm_data_disk_size" {
    type = string
    description = "Size of the managed data disk for the VM"
}
variable "vm_delete_os_disk" {
    type = string
    default = true
    description = "Delete the OS disk if the vm is deleted"
}
variable "vm_delete_data_disks" {
    type = string
    default = true
    description = "(optional) describe your variable"
}
variable "admin_username" {
    type = string
    default = "DevOps"
    description = "username to first time login to system"
}
variable "admin_password" {
    type = string
    default = "DevOps@12345"
    description = "password to first time login to system"
}
variable "tags" {
  
}