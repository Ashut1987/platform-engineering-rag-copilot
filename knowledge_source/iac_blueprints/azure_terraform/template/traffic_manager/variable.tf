variable "resource_group_name" {
    type = string
    default = "traffic_manager_rg"
}
variable "resource_location" {
    type = string
    default = "eastus2"
}
variable "traffic_manager_profile_name" {
    type = list
    default = ["tfmtest01"]
}
variable "traffic_routing_method" {
    type = string
    default = "Priority"
}
variable "traffic_manager_dns_config_relative_name" {
    type = list
    # default = [""]
}
variable "service_type" {
    type = string
    default = ""
}
variable "location_short" {
    type = string
    default = ""
}
variable "protocol" {
    type = string
    default = ""
}
variable "port" {
    type = string
    default = ""
}
variable "path" {
    type = string
    default = ""
}
variable "interval_in_seconds" {
    type = string
    default = ""
}
variable "timeout_in_seconds" {
    type = string
    default = ""
}
variable "tolerated_number_of_failures" {
    type = string
    default = ""
}
variable "environment_short" {
    type = string
    default = ""
}
variable "description" {
    type = string
    default = ""
}
variable "traffic_manager_endpoint_name" {
    type = list
}
variable "traffic_manager_endpoint_target" {
    type = list
}
variable "traffic_manager_endpoint_type" {
    type = string
}
variable "traffic_manager_endpoint_priority" {
    type = list
}
variable "traffic_manager_endpoint_location" {
    type = string
}