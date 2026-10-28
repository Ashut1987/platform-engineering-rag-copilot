variable "resource_group_name" {
    description = "Provide rg name without prefix"
}
variable "resource_location" {
    description = "Provide rg location"
}
variable "public_ip_name" {
    type = string
    description = "Public IP to access the VM form internet"
}
variable "allocation_method" {
    type = string
    description = "Public IP alloation methond - possible values are Static or Dynamic"
    default = "Dynamic"
}
variable "sku" {
    type = string
    description = "SKU for the publicip to be created, possible values - Basic or Standard"
    default = "Basic"
}
variable "nic_name" {
    type = string
    description = "Nic name"
    default = "vm-nic-01"
}
variable "nic_subnet_name" {
    type = string
    description = "Please provide the Subnet where nic belongs to"
}
variable "nic_vnet_name" {
    type = string
    description = "Please provide the Vnet name to which subnet belongs to"
}
variable "nic_address_allocation" {
    type = string
    description = "Nic private ip allocation method, possible values are Static or Dynamic"
    default = "dynamic"
}
variable "vnet_resource_group_name" {
    type = string
    description = "RG name of the VNET"
}
variable "vm_host_name" {
    description = "Host name for the VM"
}
variable "vm_zone" {
    type = string
    description = "Zone where the VM is located"
    default = "1"
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