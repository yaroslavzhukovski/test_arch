environment = "dev"
owner       = "Yaroslav"

hub_vnet_address_space = ["10.10.0.0/16"]

hub_subnets = {
  AzureFirewallSubnet = "10.10.0.0/24"
  GatewaySubnet       = "10.10.1.0/27"
  workload            = "10.10.2.0/24"
}

onprem_gateway_public_ip = "203.0.113.10"
onprem_address_prefixes  = ["192.168.10.0/24"]

spoke_vnet_address_space = ["10.20.0.0/16"]

spoke_subnets = {
  app = "10.20.1.0/24"
}
