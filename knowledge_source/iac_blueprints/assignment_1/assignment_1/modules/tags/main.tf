locals {
    default_tags = {
        tag_version = var.tag_version
        project     = var.project
        environment = var.environment
        app_name    = var.app_name
        region      = var.region
        owner       = var.owner
    }
    resource_tags = merge(local.default_tags, var.additional_tags)
}