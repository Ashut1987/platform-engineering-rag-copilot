variable "resource_group_name" {
    description = "Provide resourcegroup name"  
    default = "test_rg_01"
}
variable "resource_location" {
    default = "eastus2"
    description = "Provide resource location"  
}
variable "vnet_address_space" {
  type = list
  description = "The CIDR block reserved for this vnet"
  default = ["10.0.0.0/16"]
}
variable "vnet_name" {
  description = "Name of vnet"
  default ="vnet_test"
}
variable "dns_servers"{
    type = list
    description = "IP addresses for the DNS server"
    default = ["10.101.222.225", "10.101.222.226"]
}
variable "subnet_names" {
  type = list
  description = "Name of the identifying subnets"
  default = ["public-subnet-01","private-subnet-01","protected-subnet-01"]
}
variable "subnet_address_ranges" {
  type = list
  description = "subnets to be created on the specefied vnet"
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
variable "protected_nsg_name" {
  type = string
  default = "private_nsg_01"
}
variable "private_nsg_name" {
  type = string
  default = "private_nsg_01"
}
variable "public_nsg_name" {
  type = string
  default = "private_nsg_01"
}
variable "subnet_nsg_count" {
  type = string
  default = "3"
}
variable "service_endpoints" {
    type = list
    default = [["Microsoft.Storage","Microsoft.Keyvault"],[],["Microsoft.sql","Microsoft.Storage","Microsoft.keyvault"]]
    description = "List of service endpoints to enable. Possible values are Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDM, Microsoft.EventHub, Microsoft.keyvault, Microsoft.ServiceBus etc"
  }
variable "service_delegations" {
  type = list
  default = [
    [
        {
            name = "app-service-delegation-linux"
            service_delegation_name = "Microsoft.Web/serverFarms"
            service_delegation_action = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
    ]
]
  description = "Subnet delegations for network integration for PAAS services"
}
variable "protected_nsg_rules_map" {
  type = list
  description = "List of NSG rules to be applied to private subnet"
  default = []
}
variable "private_nsg_rules_map" {
  type = list
  description = "List of NSG rules to be applied to private subnet"
  default = []
}
variable "public_nsg_rules_map" {
  type = list
  description = "List of NSG rules to be applied to public subnet"
  default = []
}
variable "nsg_service_rules_map" {
  type = list
  description = "List of NSG rules required to leverage platform services - Domain controller, DNS, Artifactory etc"
  default = []
}
variable "nsg_private_common_rules_map" {
  type = list
  description = "List of rules required to leverage data and other services in private subnet"
  default = []
}
variable "nsg_public_common_rules_map" {
  type = list
  description = "List of rules required to leverage data and other services in public subnet"
  default = []
}
variable "subnet_route_tables" {
  type = list
  default = ["","","","","","","",""]
  description = "Route table associated with the network subnets"
}
variable "subnet_nsg_ids" {
  type = list
  default = ["","","","","","","",""]
  description = "Subnet NSGs to be assigned beyond the private, protected and public security groups"
}
// Tags //
variable "tag_version" {
    type = string
    default = "1.0.0"
}
variable "project" {
    type = string
    default = "poc"
}
variable "environment" { 
    type = string
    default = "sandbox"
}
variable "app_name" {
    type = string
    default = "terraform_test"
}
variable "region" {
    type = string
    default = "east_us"
}
variable "owner" { 
    type = string
    default = "DevOps"
}
variable "additional_tags" { 
    default = {}
}

variable "public_ip_name" {
    type = string
    default = "public_ip"
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
variable "nic_address_allocation" {
    type = string
    description = "Nic private ip allocation method, possible values are Static or Dynamic"
    default = "dynamic"
}
variable "vm_host_name" {
    description = "Host name for the VM"
    default = ["webwin2019", "servwin2019", "bkendwin2019"]
}
variable "vm_zone" {
    type = string
    description = "Zone where the VM is located"
    default = "1"
}
variable "virtual_machine_size" {
    type = string
    description = "The image sku to be used to create the VM"
    default = "Standard_ds2_v2"
}
variable "vm_os_disk_size" {
    type = string
    description = "Size of the managed OS disk for the VM"
    default = "130"
}
variable "vm_data_disk_size" {
    type = string
    description = "Size of the managed data disk for the VM"
    default = "40"
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