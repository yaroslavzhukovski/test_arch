resource "azurerm_subnet_network_security_group_association" "subnet_assoc" {
  for_each                  = azurerm_subnet.spoke_subnets
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.subnet_nsg[each.key].id
}
