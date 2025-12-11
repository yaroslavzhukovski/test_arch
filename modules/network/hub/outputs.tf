output "vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "subnet_ids" {
  value = { for k, s in azurerm_subnet.hub_subnets : k => s.id }
}

output "route_table_id" {
  value = azurerm_route_table.hub_rt.id
}

output "subnet_nsg_ids" {
  value = { for k, v in azurerm_network_security_group.subnet_nsg : k => v.id }
}
