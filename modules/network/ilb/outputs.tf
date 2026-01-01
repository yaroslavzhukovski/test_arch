output "id" {
  value = azurerm_lb.this.id
}

output "frontend_private_ip" {
  value = azurerm_lb.this.frontend_ip_configuration[0].private_ip_address
}

output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.this.id
}

module "spoke_ilb" {
  source = "./modules/network/ilb"

  name                = "${var.project_name}-${var.environment}-spoke-ilb"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name

  frontend_subnet_id = module.spoke_network.subnet_ids["app_frontend"]

  # оставим динамический IP (как в проде тоже часто ок).
  frontend_private_ip = null

  lb_port      = 80
  backend_port = 80

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
  }
}
