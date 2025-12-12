locals {
  subnets_for_routing = {
    for name, cidr in var.subnets :
    name => cidr
    if name != "AzureFirewallSubnet" && name != "GatewaySubnet"
  }
}

resource "azurerm_subnet_route_table_association" "hub_rt_assoc" {
  for_each       = local.subnets_for_routing
  subnet_id      = azurerm_subnet.hub_subnets[each.key].id
  route_table_id = azurerm_route_table.hub_rt.id
}
