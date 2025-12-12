output "id" {
  value = azurerm_virtual_network_gateway.this.id
}

output "public_ip" {
  value = azurerm_public_ip.this.ip_address
}

output "connection_id" {
  value       = var.enable_s2s ? azurerm_virtual_network_gateway_connection.this[0].id : null
  description = "S2S connection resource id (if enabled)"
}

output "local_network_gateway_id" {
  value       = var.enable_s2s ? azurerm_local_network_gateway.this[0].id : null
  description = "Local network gateway id (if enabled)"
}
