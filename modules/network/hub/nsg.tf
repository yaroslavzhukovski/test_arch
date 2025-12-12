locals {
  nsg_subnets = {
    for name, cidr in var.subnets :
    name => cidr
    if name != "GatewaySubnet" && name != "AzureFirewallSubnet"
  }
}
resource "azurerm_network_security_group" "subnet_nsg" {
  for_each            = local.nsg_subnets
  name                = "${each.key}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "subnet_assoc" {
  for_each                  = local.nsg_subnets
  subnet_id                 = azurerm_subnet.hub_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.subnet_nsg[each.key].id
}
