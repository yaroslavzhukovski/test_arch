environment = "dev"
owner       = "Yaroslav"

hub_vnet_address_space = ["10.10.0.0/16"]

hub_subnets = {
  AzureFirewallSubnet = "10.10.0.0/24"
  GatewaySubnet       = "10.10.1.0/27"
  workload            = "10.10.2.0/24"
}
