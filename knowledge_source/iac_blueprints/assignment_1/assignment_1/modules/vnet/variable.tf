variable "tags" {
    type = map
    description = "Provide mandatory tags based on org policy"  
} 
variable "resource_group_name" {
    description = "Provide resourcegroup name"  
}
variable "resource_location" {
    default = "eastus2"
    description = "Provide resource location"  
}
variable "vnet_address_space" {
  type = list
  description = "The CIDR block reserved for this vnet"
}
variable "vnet_name" {
  description = "Name of vnet"
  default ="vnet_name"
}
variable "dns_servers"{
    type = list
    description = "IP addresses for the DNS server"
}
variable "subnet_names" {
  type = list
  description = "Name of the identifying subnets"
}
variable "subnet_address_ranges" {
  type = list
  description = "subnets to be created on the specefied vnet"
}
variable "subnet_nsg_count" {
  default = 3
  description = "Number of NSGs to associate" 
}

variable "subnet_nsg_ids" {
  type = list
  description = "List if ids for the NSG to be associated with the subnet"
}
variable "subnet_route_tables" {
  type = list
  description = "List of routes associated with the defined subnets"
}
variable "service_endpoints" {
    type = list
    default = []
    description = "List of service endpoints to enable. Possible values are Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDM, Microsoft.EventHub, Microsoft.keyvault, Microsoft.ServiceBus etc"
  }
variable "service_delegations" {
  type = list
  default = []
  description = "Subnet delegations for network integration for PAAS services"
}