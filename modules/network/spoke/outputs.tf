output "vnet_id" {
  value = azurerm_virtual_network.spoke.id
}

output "vnet_name" {
  value = azurerm_virtual_network.spoke.name
}

output "subnet_ids" {
  value = { for k, s in azurerm_subnet.spoke_subnets : k => s.id }
}

output "subnet_nsg_ids" {
  value = { for k, v in azurerm_network_security_group.subnet_nsg : k => v.id }
}
