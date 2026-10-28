variable "resource_group_name" {
    description = "Provide resourcegroup name"  
}
variable "resource_location" {
    default = "eastus2"
    description = "Provide resource location"  
}
variable "vnet_address_space" {
  type = "list"
  description = "The CIDR block reserved for this vnet"
}
variable "vnet_name" {
  description = "Name of vnet"
  default ="vnet_test"
}
variable "dns_servers"{
    type = "list"
    description = "IP addresses for the DNS server"
    default = ["10.101.222.225", "10.101.222.226"]
}
variable "subnet_names" {
  type = "list"
  description = "Name of the identifying subnets"
  default = ["public-subnet-01","private-subnet-01"]
}
variable "subnet_address_ranges" {
  type = "list"
  description = "subnets to be created on the specefied vnet"
}
variable "service_endpoints" {
    type = "list"
    default = [["Microsoft.Storage","Microsoft.Keyvault"],[],["Microsoft.sql","Microsoft.Storage","Microsoft.keyvault"]]
    description = "List of service endpoints to enable. Possible values are Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDM, Microsoft.EventHub, Microsoft.keyvault, Microsoft.ServiceBus etc"
  }
variable "service_delegations" {
  type = "list"
  default = []
  description = "Subnet delegations for network integration for PAAS services"
}
variable "private_nsg_rules_map" {
  type = "list"
  description = "List of NSG rules to be applied to private subnet"
  default = []
}
variable "public_nsg_rules_map" {
  type = "list"
  description = "List of NSG rules to be applied to public subnet"
  default = []
}
variable "nsg_service_rules_map" {
  type = "list"
  description = "List of NSG rules required to leverage platform services - Domain controller, DNS, Artifactory etc"
  default = []
}
variable "nsg_private_common_rules_map" {
  type = "list"
  description = "List of rules required to leverage data and other services in private subnet"
  default = []
}
variable "nsg_public_common_rules_map" {
  type = "list"
  description = "List of rules required to leverage data and other services in public subnet"
  default = []
}
variable "subnet_route_tables" {
  type = "list"
  default = ["","","","","","","",""]
  description = "Route table associated with the network subnets"
}
variable "subnet_nsg_ids" {
  type = "list"
  default = ["","","","","","","",""]
  description = "Subnet NSGs to be assigned beyond the private, protected and public security groups"
}



