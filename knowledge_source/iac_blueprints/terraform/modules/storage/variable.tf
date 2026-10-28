variable "resource_group_name" {
  description = "Provide rg name"
}
variable "resource_location" {
  default = "eastus2"
  description = "Location for the rg"
}
variable "storage_name" {
  description = "Name of the storage to cretate"
}
variable "storage_account_kind" {
  description = "Type of storage account to be created. Acceptable values are Storage, StorageV2 and BlobStorage"
  default ="StorageV2"
}
variable "storage_account_tier" {
  description = "Tier to use for this storage account. Valid options are Standard and Platinum"
  default = "Standard"
}
variable "storage_account_replication_type" {
  description = "Type of replication to use for this storage account, Valid options are LRS, GRS, RAGRS and ZRS"
  default = "GRS"
}
variable "storage_access_tier" {
  description = "Access tier for Blobstorage and StorageV2 accounts. valid options are Hot and Cool"
  default = "Hot"
}
variable "storage_subnet_name" {
  description = "Subnet name for the storage"
}
variable "storage_vnet_name" {
  description = "Vnet which the subnet belongs to"
}
variable "storage_containers" {
  description = "Containers to create in the storage account"
  type = "list"
  default = []
}
variable "vnet_resource_group_name" {
  description = "RG name of the vnet"
}
variable "additional_local_subnets" {
  type = "list"
  default = []
  description = " Additional service endpoints for the storage account on the subscriptions Vnets"
}












