output "vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "subnet_ids" {
  value = { for k, s in azurerm_subnet.hub_subnets : k => s.id }
}
