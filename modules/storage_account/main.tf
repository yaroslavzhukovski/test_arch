locals {
  endpoints = toset(["blob", "queue", "table", "file"])

  private_dns_zone_names = {
    blob  = "privatelink.blob.core.windows.net"
    queue = "privatelink.queue.core.windows.net"
    table = "privatelink.table.core.windows.net"
    file  = "privatelink.file.core.windows.net"
  }
}

resource "azurerm_private_dns_zone" "this" {
  for_each = local.endpoints

  name                = local.private_dns_zone_names[each.key]
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = azurerm_private_dns_zone.this

  name                  = "${each.key}-${var.vnet_name}-link"
  private_dns_zone_name = each.value.name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

module "storage" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.6.7"

  location            = var.location
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "ZRS"

  min_tls_version                         = "TLS1_2"
  public_network_access_enabled           = false
  shared_access_key_enabled               = false
  private_endpoints_manage_dns_zone_group = true

  network_rules = {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }

  containers = var.containers
  queues     = var.queues
  shares     = var.shares
  tables     = var.tables

  private_endpoints = {
    for endpoint in local.endpoints :
    endpoint => {
      name                            = "pe-${endpoint}-${var.storage_account_name}"
      subnet_resource_id              = var.private_endpoint_subnet_id
      subresource_name                = endpoint
      private_dns_zone_resource_ids   = [azurerm_private_dns_zone.this[endpoint].id]
      private_service_connection_name = "psc-${endpoint}-${var.storage_account_name}"
      network_interface_name          = "nic-pe-${endpoint}-${var.storage_account_name}"
      tags                            = var.tags
    }
  }

  tags = var.tags
}
