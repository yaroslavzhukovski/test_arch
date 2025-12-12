resource "azurerm_route_table" "hub_rt" {
  name                = "${var.vnet_name}-rt"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_route" "default_to_firewall" {
  name                = "default-to-firewall"
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.hub_rt.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance"

  # Здесь будет IP Firewall — добавим позже
  next_hop_in_ip_address = module.firewall.private_ip
}
