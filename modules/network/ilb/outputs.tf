output "id" {
  value = azurerm_lb.this.id
}

output "frontend_private_ip" {
  value = azurerm_lb.this.frontend_ip_configuration[0].private_ip_address
}

output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.this.id
}

