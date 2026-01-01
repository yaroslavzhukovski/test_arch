locals {
  spoke_nsgs = var.subnets
}

resource "azurerm_network_security_group" "subnet_nsg" {
  for_each            = local.spoke_nsgs
  name                = "${var.vnet_name}-${each.key}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "security_rule" {
    for_each = each.key == "app_backend" ? [1] : []
    content {
      name                       = "allow-http-from-frontend"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = var.subnets["app_frontend"]
      destination_address_prefix = "*"
    }
  }

  dynamic "security_rule" {
    for_each = each.key == "app_backend" ? [1] : []
    content {
      name                       = "allow-lb-health-probe"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    }
  }
}
