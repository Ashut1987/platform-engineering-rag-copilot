resource "azurerm_network_security_group" "generic_nsg" {
  name     = var.nsg_name
  location = var.resource_location
  resource_group_name  = var.resource_group_name
  
  tags = var.tags
}

 resource "azurerm_network_security_rule" "nsg_rule_map_applied" {
   count = length(var.nsg_rules_map)

   name = lookup(var.nsg_rules_map[count.index], "rule_name")
   description = lookup(var.nsg_rules_map[count.index], "rule_description")
   priority = lookup(var.nsg_rules_map[count.index], "rule_priority")
   direction = lookup(var.nsg_rules_map[count.index], "rule_direction")
   access = lookup(var.nsg_rules_map[count.index], "rule_access")
   protocol = lookup(var.nsg_rules_map[count.index], "rule_protocol")
   source_port_range = lookup(var.nsg_rules_map[count.index], "rule_source_port_range")
   source_address_prefix = lookup(var.nsg_rules_map[count.index], "rule_source_address_prefix")
   destination_port_range = lookup(var.nsg_rules_map[count.index], "rule_dest_port_range")
   destination_address_prefix = lookup(var.nsg_rules_map[count.index], "rule_destination_address_prefix")
   resource_group_name = var.resource_group_name
   network_security_group_name = azurerm_network_security_group.generic_nsg.name
 }