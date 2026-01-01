resource "azurerm_lb" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "fe"
    subnet_id                     = var.frontend_subnet_id
    private_ip_address_allocation = var.frontend_private_ip == null ? "Dynamic" : "Static"
    private_ip_address            = var.frontend_private_ip
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "this" {
  name            = "be-pool"
  loadbalancer_id = azurerm_lb.this.id
}

resource "azurerm_lb_probe" "this" {
  name            = "http-probe"
  loadbalancer_id = azurerm_lb.this.id
  protocol        = "Tcp"
  port            = var.backend_port
}

resource "azurerm_lb_rule" "this" {
  name                           = "rule-${var.lb_port}-to-${var.backend_port}"
  loadbalancer_id                = azurerm_lb.this.id
  protocol                       = "Tcp"
  frontend_port                  = var.lb_port
  backend_port                   = var.backend_port
  frontend_ip_configuration_name = "fe"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.this.id]
  probe_id                       = azurerm_lb_probe.this.id
}
