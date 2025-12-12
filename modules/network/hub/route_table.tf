resource "azurerm_route_table" "hub_rt" {
  name                = "${var.vnet_name}-rt"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}


