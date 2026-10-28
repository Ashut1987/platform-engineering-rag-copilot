provider "azurerm" {
  subscription_id = "d276ebc2-efd2-4b53-9eb4-304982e42f4b"
  features {}
}
data "azurerm_subnet" "private_subnet"{
  name = "${var.storage_subnet_name}"
  virtual_network_name = "${var.storage_vnet_name}"
  resource_group_name ="${var.vnet_resource_group_name}"
}
data "azurerm_subnet" "public_subnet"{
  name = "${var.storage_subnet_name}"
  virtual_network_name = "${var.storage_vnet_name}"
  resource_group_name ="${var.vnet_resource_group_name}"
}
data "azurerm_subnet" "additional_subnets"{
  count = "${length(var.additional_local_subnets)}"

  name = "${element(var.additional_local_subnets, count.index)}"
  virtual_network_name = "${var.storage_vnet_name}"
  resource_group_name ="${var.vnet_resource_group_name}"
}
resource "azurerm_storage_account" "storage" {
  name                         = "${var.storage_name}"
  location                     = "${var.resource_location}"
  resource_group_name          = "${var.resource_group_name}"
  account_kind = "${var.storage_account_kind}"
  account_tier = "${var.storage_account_tier}"
  account_replication_type = "${var.storage_account_replication_type}"
  access_tier = "${var.storage_access_tier}"

  #enable_blob_encription = true
  #enable_file_encription = true
  #enable_https_traffic_only = true

  network_rules {
    default_action = "Deny"
    bypass = ["Azureservices"]
    virtual_network_subnet_ids = "${concat([data.azurerm_subnet.public_subnet.id,data.azurerm_subnet.private_subnet.id])}"
    ip_rules = []
  }
 
}
resource "azurerm_storage_container" "container" {
  count = "${length(var.storage_containers)}"

  name = "${element(var.storage_containers, count.index)}"
  storage_account_name = "${azurerm_storage_account.storage.name}"
  container_access_type = "private"
}