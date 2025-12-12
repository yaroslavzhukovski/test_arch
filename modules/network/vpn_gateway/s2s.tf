resource "azurerm_local_network_gateway" "this" {
  count               = var.enable_s2s ? 1 : 0
  name                = "${var.name}-lng"
  location            = var.location
  resource_group_name = var.resource_group_name

  gateway_address = var.onprem_gateway_public_ip
  address_space   = var.onprem_address_prefixes

  tags = var.tags
}

resource "azurerm_virtual_network_gateway_connection" "this" {
  count               = var.enable_s2s ? 1 : 0
  name                = "${var.name}-s2s"
  location            = var.location
  resource_group_name = var.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.this.id
  local_network_gateway_id   = azurerm_local_network_gateway.this[0].id
  shared_key                 = var.shared_key

  # Optional but common defaults:
  connection_protocol = "IKEv2"

  tags = var.tags
}
