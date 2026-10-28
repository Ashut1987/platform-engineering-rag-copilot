provider "azurerm" {
  features {}    
}
module "tags" {
  source = "../../modules/tags"
  
  tag_version     = var.tag_version
  project         = var.project
  environment     = var.environment
  app_name        = var.app_name
  region          = var.region
  owner           = var.owner
  additional_tags = var.additional_tags
}
module "default_resource_group" {
    source = "../../modules/resource_group"

    resource_location   = var.resource_location
    resource_group_name = var.resource_group_name
    tags                = local.mandatory_tags
}
locals {
    mandatory_tags = module.tags.mandatory_tags
    resource_group_name = module.default_resource_group.name
    prefix_vnet = "${module.default_resource_group.name}-vnet-"
    default_protected_nsg_rules_map = [
        {
            rule_name                                                 = "azure_autoconfig_out"
            rule_description                                          = "Allow outbound access to Azure's special config IP"
            rule_priority                                             = "2001"
            rule_access                                               = "Allow"
            rule_direction                                            = "Outbound"
            rule_protocol                                             = "*"
            rule_source_address_prefix                                = "*"
            rule_source_port_range                                    = "*"
            rule_destination_address_prefix                           = "168.63.129.16/32"
            rule_dest_port_range                                      = "*"
        },
        {
            rule_name                                                 = "http_out"
            rule_description                                          = "Allow outbound http access"
            rule_priority                                             = "3000"
            rule_access                                               = "Allow"
            rule_direction                                            = "Outbound"
            rule_protocol                                             = "Tcp"
            rule_source_address_prefix                                = "*"
            rule_source_port_range                                    = "*"
            rule_destination_address_prefix                           = "*"
            rule_dest_port_range                                      = "80"
        },
        {
            rule_name                                                 = "https_out"
            rule_description                                          = "Allow outbound http access"
            rule_priority                                             = "3100"
            rule_access                                               = "Allow"
            rule_direction                                            = "Outbound"
            rule_protocol                                             = "Tcp"
            rule_source_address_prefix                                = "*"
            rule_source_port_range                                    = "*"
            rule_destination_address_prefix                           = "*"
            rule_dest_port_range                                      = "443"
         }
    ]
    default_private_nsg_rules_map = [
        {
            rule_name                                                 = "vnet_inbound"
            rule_description                                          = "Allow VNET Inbound"
            rule_priority                                             = "1001"
            rule_access                                               = "Allow"
            rule_direction                                            = "Inbound"
            rule_protocol                                             = "*"
            rule_source_address_prefix                                = "VirtualNetwork"
            rule_source_port_range                                    = "*"
            rule_destination_address_prefix                           = "VirtualNetwork"
            rule_dest_port_range                                      = "*"
        },
        {
            rule_name                                                 = "azure_autoconfig_in"
            rule_description                                          = "Allow inbound access from Azure's special config IP"
            rule_priority                                             = "1004"
            rule_access                                               = "Allow"
            rule_direction                                            = "Inbound"
            rule_protocol                                             = "*"
            rule_source_address_prefix                                = "168.63.129.16/32"
            rule_source_port_range                                    = "*"
            rule_destination_address_prefix                           = "*"
            rule_dest_port_range                                      = "*"
        },
        {
            rule_name                                                 = "vnet_outbound"
            rule_description                                          = "Allow VNET Outbound"
            rule_priority                                             = "2000"
            rule_access                                               = "Allow"
            rule_direction                                            = "Outbound"
            rule_protocol                                             = "*"
            rule_source_address_prefix                                = "VirtualNetwork"
            rule_source_port_range                                    = "*"
            rule_destination_address_prefix                           = "VirtualNetwork"
            rule_dest_port_range                                      = "*"
        }
    ]   
    default_public_nsg_rules_map = [
        {
            rule_name                                                 = "vnet_inbound"
            rule_description                                          = "Allow VNET Inbound"
            rule_priority                                             = "1001"
            rule_access                                               = "Allow"
            rule_direction                                            = "Inbound"
            rule_protocol                                             = "*"
            rule_source_address_prefix                                = "VirtualNetwork"
            rule_source_port_range                                    = "*"
            rule_destination_address_prefix                           = "VirtualNetwork"
            rule_dest_port_range                                      = "*"
        }]
       
}
module "protected_nsg" {
    source = "../../modules/nsg"

     resource_location = var.resource_location
     resource_group_name = local.resource_group_name
     
     nsg_name       = var.protected_nsg_name
     nsg_rules_map  = concat(local.default_protected_nsg_rules_map, var.nsg_service_rules_map, var.nsg_private_common_rules_map, var.private_nsg_rules_map)
     
     tags           = local.mandatory_tags
     depends_on     = [ module.default_resource_group ]
}
module "private_nsg" {
    source = "../../modules/nsg"

     resource_location = var.resource_location
     resource_group_name = local.resource_group_name
     
     nsg_name = var.private_nsg_name
     nsg_rules_map = concat(local.default_private_nsg_rules_map, var.nsg_service_rules_map, var.nsg_private_common_rules_map, var.private_nsg_rules_map)
     
     tags           = local.mandatory_tags
     depends_on     = [ module.default_resource_group ]
}
module "public_nsg" {
    source = "../../modules/nsg"
     resource_location = var.resource_location
     resource_group_name = local.resource_group_name
     nsg_name = var.public_nsg_name
     nsg_rules_map = concat(local.default_public_nsg_rules_map, var.nsg_public_common_rules_map, var.public_nsg_rules_map)
     
     tags           = local.mandatory_tags
     depends_on     = [ module.default_resource_group ]
}

module "management_vnet" {
    source = "../../modules/vnet"

    resource_location   = var.resource_location
    resource_group_name = local.resource_group_name

    vnet_address_space = var.vnet_address_space
    vnet_name          = var.vnet_name
    dns_servers        = var.dns_servers
    subnet_names       = var.subnet_names
    subnet_address_ranges = var.subnet_address_ranges
    subnet_nsg_count      = var.subnet_nsg_count
    subnet_nsg_ids        = concat(list(module.protected_nsg.id, module.private_nsg.id, module.public_nsg.id), var.subnet_nsg_ids)
    subnet_route_tables   = var.subnet_route_tables
    service_endpoints     = var.service_endpoints
    service_delegations   = var.service_delegations

    tags           = local.mandatory_tags
    depends_on     = [ module.default_resource_group ]
}

module "default_public_ip" {
     source = "../../modules/publicip"
     
     public_ip_name = var.public_ip_name
     resource_location = var.resource_location
     resource_group_name = var.resource_group_name
     allocation_method   = var.allocation_method
     sku = var.sku
     tags = local.mandatory_tags
 }

module "default_nic" {
      source = "../../modules/network_interface"
      
      count = length(var.vm_host_name)
      resource_location   = var.resource_location
      resource_group_name = var.resource_group_name

      nic_name                 = var.vm_host_name[count.index]
      nic_subnet_name          = var.subnet_names[count.index]
      nic_vnet_name            = var.vnet_name
      nic_address_allocation   = var.nic_address_allocation
      vnet_resource_group_name = local.resource_group_name
      public_ip_address_id     = count.index == 1 ? module.default_public_ip.id : null
      depends_on = [ module.default_resource_group, module.management_vnet]

      tags = local.mandatory_tags
}

module "vm_config" {
      source = "../../modules/vm_windows"

      count = length(var.vm_host_name)
      resource_location     = var.resource_location
      resource_group_name   = var.resource_group_name
      vm_zone = var.vm_zone

      nic_id = module.default_nic[count.index].id

      virtual_machine_name = var.vm_host_name[count.index]
      vm_host_name = var.vm_host_name[count.index]
      vm_os_disk_size = var.vm_os_disk_size
      vm_data_disk_size = var.vm_data_disk_size
      vm_delete_data_disks = var.vm_delete_data_disks
      virtual_machine_size =var.virtual_machine_size
      depends_on = [ module.default_resource_group, module.management_vnet]
      tags = local.mandatory_tags

      
}