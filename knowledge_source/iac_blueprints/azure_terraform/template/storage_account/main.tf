/*module "default_resource_tags"{
   source = "../../module/tags"  
}
locals {
    mandatory_tags = "${module.default_resource_tags.mandatory_tags}"
    resource_location = "${module.default_resource_tags.default_location}"
} */
module "storage" {
    source = "../../modules/storage"

    resource_group_name = "${var.resource_group_name}"
    resource_location = "${var.resource_location}"
    storage_name = "${var.storage_name}"

    storage_account_kind = "${var.storage_account_kind}"
    storage_account_tier = "${var.storage_account_tier}"
    storage_account_replication_type = "${var.storage_account_replication_type}"
    storage_access_tier = "${var.storage_access_tier}"
    #subscription_ids = "${var.subscription_ids}"

    storage_subnet_name = "${var.storage_subnet_name}"
    storage_vnet_name = "${var.storage_vnet_name}"
    vnet_resource_group_name = "${var.vnet_resource_group_name}"
    storage_containers = "${var.storage_containers}"

   
}