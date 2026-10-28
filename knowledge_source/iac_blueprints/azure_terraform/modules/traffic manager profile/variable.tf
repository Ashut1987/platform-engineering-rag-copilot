variable "resource_group_name" {
    type = string
    default = ""
}
variable "traffic_manager_profile_name" {
    type = string
    default = ""
}
variable "traffic_routing_method" {
    type = string
    default = ""
}
variable "traffic_manager_dns_config_relative_name" {
    type = string
    default = ""
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
variable "tags" {
    type = map
}