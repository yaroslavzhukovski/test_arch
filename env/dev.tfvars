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
  app_frontend      = "10.20.1.0/24"
  app_backend       = "10.20.2.0/24"
  private_endpoints = "10.20.10.0/27"
}

admin_username = "azureuser"
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUFFSAJCQVzQnQZ8alhObp0XRPk55qe9F6LXxYBU408bkOPa9IJ/7zorb9TKdoRJ9+JObUXl9r6+XF9CGgMWOmbTA/tR0HmEfPz+Pz2s9o6wks0frRu1Z0m9tlpNfZpIDO1huiXcYZFKZiv2FKe3OfUXkJMF1QUla6oJQRQFKxb9VBX/BtNXvM66KCUAEC4HSjkqN0kaUs6wcPTmVBV/NzrMbFiMgtgD0CKKF6nlB0EJUzj4fqo7igQZwfh6VE/wmmPMPZ9DPXtKLA9nF2FYVeb8JBQ6MrEBpt+oWyhcxMBFBbU4ADTXjiOkdheo3u1vTZgVcf7IkeuhPgCOYCf0tR"
