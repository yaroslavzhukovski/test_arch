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

resource "azurerm_route" "default_to_firewall" {
  name                = "default-to-firewall"
  resource_group_name = azurerm_resource_group.platform.name
  route_table_name    = module.hub_network.route_table_name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance"


  next_hop_in_ip_address = module.firewall.private_ip
}
module "vpn_gateway" {
  source = "./modules/network/vpn_gateway"

  name                = "${var.project_name}-${var.environment}-vpngw"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location

  gateway_subnet_id = module.hub_network.subnet_ids["GatewaySubnet"]

  sku                      = "VpnGw1AZ"
  enable_bgp               = true
  bgp_asn                  = 65515
  active_active            = false
  enable_s2s               = true
  onprem_gateway_public_ip = var.onprem_gateway_public_ip
  onprem_address_prefixes  = var.onprem_address_prefixes
  shared_key               = var.vpn_shared_key

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
  }
}
