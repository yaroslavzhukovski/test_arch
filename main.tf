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

module "spoke_network" {
  source = "./modules/network/spoke"

  vnet_name           = "${var.project_name}-${var.environment}-spoke-vnet"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name

  address_space = var.spoke_vnet_address_space
  subnets       = var.spoke_subnets

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
  }
}

module "hub_spoke_peering" {
  source = "./modules/network/peering"

  resource_group_name = azurerm_resource_group.platform.name

  hub_vnet_id   = module.hub_network.vnet_id
  hub_vnet_name = module.hub_network.vnet_name


  spoke_vnet_id   = module.spoke_network.vnet_id
  spoke_vnet_name = module.spoke_network.vnet_name

  hub_to_spoke_name = "hub-to-spoke"
  spoke_to_hub_name = "spoke-to-hub"

  allow_gateway_transit = true
  use_remote_gateways   = true
}
locals {
  vmss_cloud_init = <<-EOT
#cloud-config
package_update: true
packages:
  - nginx
runcmd:
  - systemctl enable nginx
  - systemctl start nginx
  - bash -lc 'cat > /var/www/html/index.html <<EOF
<html>
  <head><title>VMSS backend</title></head>
  <body style="font-family: Arial;">
    <h1>✅ Hello from VMSS</h1>
    <p>Environment: ${var.environment}</p>
    <p>Project: ${var.project_name}</p>
  </body>
</html>
EOF'
EOT

  hub_subnets_for_routing = {
    for name, id in module.hub_network.subnet_ids :
    name => id
    if name != "AzureFirewallSubnet" && name != "GatewaySubnet"
  }

  split_routes = {
    "default-to-firewall" = {
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "VirtualAppliance"
      next_hop_ip    = module.firewall.private_ip
    }

    "onprem" = {
      address_prefix = var.onprem_address_prefixes[0]
      next_hop_type  = "VirtualNetworkGateway"
    }
  }
}

module "hub_route_table" {
  source = "./modules/network/route_table"

  name                = "${var.project_name}-${var.environment}-hub-rt"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name

  subnet_ids = local.hub_subnets_for_routing

  routes = local.split_routes


  tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
  }
}

module "spoke_route_table" {
  source = "./modules/network/route_table"

  name                = "${var.project_name}-${var.environment}-spoke-rt"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name

  subnet_ids = module.spoke_network.subnet_ids

  routes = local.split_routes


  tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
  }
}

module "spoke_vmss" {
  source = "./modules/compute/vmss_flexible"

  name                = "${var.project_name}-${var.environment}-spoke-vmss"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name

  subnet_id       = module.spoke_network.subnet_ids["app_backend"]
  backend_pool_id = module.spoke_ilb.backend_pool_id

  instances = 2
  sku_name  = "Standard_B2s"

  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
  custom_data    = local.vmss_cloud_init

  tags = local.tags
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
