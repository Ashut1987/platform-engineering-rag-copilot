locals {
    resource_type = "appi"
    name = lower("${local.resource_type}-${var.service_type}-${var.location_short}-${var.environment_short}-${var.description}")
}