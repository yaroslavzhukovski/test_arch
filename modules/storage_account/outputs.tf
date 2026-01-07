output "storage_account_id" {
  value = module.storage.resource_id
}

output "private_endpoints" {
  value = module.storage.private_endpoints
}

output "private_dns_zone_ids" {
  value = { for k, z in azurerm_private_dns_zone.this : k => z.id }
}
