provider "azurerm" {
  subscription_id = "d276ebc2-efd2-4b53-9eb4-304982e42f4b"
  features {}
}
/*module "default_resource_tags" {
  source = "../../modules/tags"  
} 
locals {
  //  mandatory_tags = "${module.default_resource_tags.mandatory_tags}"
    resource_loaction = "${module.default_resource_tags}"
} */
module "default_resource_group" {
    source = "../../modules/resource_group"

    resource_location = var.resource_location
    resource_group_name = var.resource_group_name
  //  mandatory_tags = "${local.mandatory_tags}"
}
locals {
    resource_group_name = module.default_resource_group.default_resource_group_name
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
        },
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
            rule_protocol                                             = "tcp"
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
            rule_protocol                                             = "tcp"
            rule_source_address_prefix                                = "*"
            rule_source_port_range                                    = "*"
            rule_destination_address_prefix                           = "*"
            rule_dest_port_range                                      = "443"
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
        },
     /*   {
            rule_name                                                 = "http_in"
            rule_description                                          = "Allow http in for HTTP->HTTPS redirect (controlled by Apache config) and LetsEncrypt"
            rule_priority                                             = "1002"
            rule_access                                               = "Allow"
            rule_direction                                            = "Inbound"
            rule_protocol                                             = "tcp"
            rule_source_address_prefixes                              = "${var.optum_addresses}"
            rule_source_port_range                                    = "*"
            rule_destination_address_prefix                           = "${var.subnet_web_address_space_region1}"
            rule_destination_port_range                               = "80"
        },
        {
            rule_name                                                 = "https_in_optum"
            rule_description                                          = "Allow https in from Optum networks"
            rule_priority                                             = "1003"
            rule_access                                               = "Allow"
            rule_direction                                            = "Inbound"
            rule_protocol                                             = "tcp"
            rule_source_address_prefixes                              = "${var.optum_addresses}"
            rule_source_port_range                                    = "*"
            rule_destination_address_prefix                           = "${var.subnet_web_address_space_region1}"
            rule_destination_port_range                               = "443"
        }, */
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
        },
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
            rule_protocol                                             = "tcp"
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
            rule_protocol                                             = "tcp"
            rule_source_address_prefix                                = "*"
            rule_source_port_range                                    = "*"
            rule_destination_address_prefix                           = "*"
            rule_dest_port_range                                      = "443"
        }
    ]    
}
module "private_nsg" {
    source = "../../modules/nsg"
     resource_location = var.resource_location
     resource_group_name = local.resource_group_name
   //  mandatory_tags = local.mandatory_tags
     nsg_name = "private-nsg-01"
     nsg_rules_map = "${concat(local.default_private_nsg_rules_map, var.nsg_service_rules_map, var.nsg_private_common_rules_map, var.private_nsg_rules_map)}"
}
module "public_nsg" {
    source = "../../modules/nsg"
     resource_location = var.resource_location
     resource_group_name = local.resource_group_name
   //  mandatory_tags = "${local.mandatory_tags}"
     nsg_name = "public-nsg-01"
     nsg_rules_map = "${concat(local.default_public_nsg_rules_map, var.nsg_public_common_rules_map, var.public_nsg_rules_map)}"
}

module "management_vnet" {
    source = "../../modules/vnet"

    resource_location = var.resource_location
    resource_group_name = local.resource_group_name
 //   mandatory_tags = local.mandatory_tags

    vnet_address_space = var.vnet_address_space
    vnet_name = var.vnet_name
    dns_servers = var.dns_servers
    subnet_names = var.subnet_names
    subnet_address_ranges = var.subnet_address_ranges
    subnet_nsg_count = 2
    subnet_nsg_ids = "${concat(list(module.private_nsg.id, module.public_nsg.id), var.subnet_nsg_ids)}"
    subnet_route_tables = var.subnet_route_tables
    service_endpoints = var.service_endpoints
    service_delegations = var.service_delegations
  //  enforce_private_link_endpoint_network_policies = var.enforce_private_link_endpoint_network_policies
  //  enforce_private_link_service_network_policies = var.enforce_private_link_service_network_policies
}