resource "azurerm_virtual_network" "generic_vnet" {
  name     = var.vnet_name
  location = var.resource_location
  resource_group_name  = var.resource_group_name
  address_space = var.vnet_address_space
  dns_servers = var.dns_servers
 // tags = var.mandatory_tags
}

 resource "azurerm_subnet" "generic_subnet" {
   count = length(var.subnet_names)

   name = element(var.subnet_names, count.index)
   resource_group_name = var.resource_group_name
   virtual_network_name = azurerm_virtual_network.generic_vnet.name
   address_prefixes = element(var.subnet_address_ranges, count.index)
   service_endpoints = element(var.service_endpoints, count.index)

   dynamic delegation {
     for_each = element(var.service_delegations, count.index)
     content {
       name = delegation.value["name"]
       service_delegation {
         name = delegation.value["service_delegation_name"]
         actions = delegation.value["service_delegation_action"]
       }
     }
   }
   
 //  network_security_group_id = "${element(var.subnet_nsg_ids, count.index)}"
 //  route_table_id = "${element(var.subnet_route_tables, count.index)}"
 }
  
  resource "azurerm_subnet_network_security_group_association" "generic_nsg_association" {
    count = var.subnet_nsg_count
    subnet_id = azurerm_subnet.generic_subnet[count.index].id
    network_security_group_id = var.subnet_nsg_ids[count.index]
  }