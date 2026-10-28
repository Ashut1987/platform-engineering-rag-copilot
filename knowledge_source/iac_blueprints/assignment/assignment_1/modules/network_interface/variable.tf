variable "resource_group_name" {
    description = "Provide resourcegroup name"  
}
variable "resource_location" {
    description = "Provide resource location"  
}
variable "nic_name" {
    default = "app-nic-01"
    description = "Primary nic card name which will attach to VM"  
}
variable "nic_address_allocation" {
    default = "dynamic"
    description = "Address allocation type - static or dynamic"  
}
variable "nic_ip_address" {
    default = ""
    description = "Private ip address when ip allocation is static"  
}
variable "nic_subnet_name" {
    description = "Subnet name for the nic"  
}
variable "nic_vnet_name" {
    description = "Vnet which the subnet belongs to"  
}
variable "nic_nsg_id" {
    default = ""
    description = "ID for the NSG to be associated with the nic"  
}
variable "vnet_resource_group_name" {
    default = ""
    description = "Name of resourcegroup where the Vnet is created"  
}
variable "is_primary_nic" {
    default = true
    description = "Specify if this will be the primary nic if more than one nics are present"  
}
variable "public_ip_address_id" {
     description = "Public IP id to be pass to associate it"
}
variable "tags" {
    description = "Please provide tags"  
}
