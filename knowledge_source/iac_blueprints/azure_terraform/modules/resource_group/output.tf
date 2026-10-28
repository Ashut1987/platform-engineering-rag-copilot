output "default_location" {
    value = "${var.resource_location}"
}

output "default_resource_group_name" {
    value = "${local.resource_group_created_name}"
}
