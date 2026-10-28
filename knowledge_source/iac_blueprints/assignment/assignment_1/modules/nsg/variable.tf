variable "resource_group_name" {
    description = "Provide resourcegroup name"  
}
variable "resource_location" {
    default = "eastus2"
    description = "Provide resource location"  
}
variable "nsg_name" {
  description = "Name of NSG"
}
variable "nsg_rules_map" {
  type = list
  description = "Allow public subnet to the subnet this rule is assigned"
  default = []
}
variable "tags" {
  description = "Provide tags"
}