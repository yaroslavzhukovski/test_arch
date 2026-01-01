resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = var.hub_to_spoke_name
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = var.spoke_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # Важно для hub-spoke с VPN Gateway в hub:
  allow_gateway_transit = var.allow_gateway_transit
}
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = var.spoke_to_hub_name
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.spoke_vnet_name
  remote_virtual_network_id = var.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # Spoke использует VPN Gateway из hub:
  use_remote_gateways = var.use_remote_gateways
}
