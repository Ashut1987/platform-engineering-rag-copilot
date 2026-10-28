variable "resource_group_name" {
    description = "Provide resourcegroup name"  
    type = string
    default = "my_rg"
}
variable "resource_location" {
    description = "Provide resource location"  
}
variable "tags" {
    description = "Provide tags" 
    type = map 
}
