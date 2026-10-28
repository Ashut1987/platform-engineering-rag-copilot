variable "resource_group_name" {
    description = "Provide resource group name"  
}
variable "resource_location" {
    default = "eastus"
    description = "Provide resource location"  
}
variable "allocation_method" {
    default = "Static"
    description = "ip allocation method"
}
variable "bastion_subnet_name" {
   description = "Bastion Subnet name"
}
variable "bastion_vnet_name" {
    description = "Bastion Vnet Name"
}
variable "bation_vnet_resource_group_name" {
    description = "Bastion Vnet resource group name"
}
variable "sku" {
    default = "Basic"
    description = "Public IP SKU type"
}
variable "bastion_host_name" {
    description = "Bastion host name"
}
variable "public_ip_name" {
    description = "public ip name"
}
