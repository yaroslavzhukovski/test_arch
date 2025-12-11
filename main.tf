resource "azurerm_resource_group" "platform" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
  tags     = local.tags
}

module "hub_network" {
  source = "./modules/network/hub"

  vnet_name           = "${var.project_name}-${var.environment}-hub-vnet"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name

  address_space = var.hub_vnet_address_space
  subnets       = var.hub_subnets

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
  }
}

module "firewall" {
  source = "./modules/network/firewall"

  firewall_name            = "${var.project_name}-${var.environment}-afw"
  resource_group_name      = azurerm_resource_group.platform.name
  location                 = azurerm_resource_group.platform.location
  azure_firewall_subnet_id = module.hub_network.subnet_ids["AzureFirewallSubnet"]

  sku_tier = "Standard" # or "Premium"

  # When you have Log Analytics module ready, pass its id here instead of null
  log_analytics_workspace_id = null

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
  }
}
