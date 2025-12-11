resource "azurerm_public_ip" "this" {
  name                = "${var.firewall_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_firewall_policy" "this" {
  name                = "${var.firewall_name}-policy"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku_tier

  # For now policy is empty – later we will add rule collections here
}

resource "azurerm_firewall" "this" {
  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = "AZFW_VNet"
  sku_tier = var.sku_tier

  firewall_policy_id = azurerm_firewall_policy.this.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.azure_firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.this.id
  }

  threat_intel_mode = "Alert" # can be "Deny" later if you want stricter mode

  tags = var.tags
}
