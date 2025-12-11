variable "firewall_name" {
  type        = string
  description = "Name of Azure Firewall"
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "azure_firewall_subnet_id" {
  type        = string
  description = "ID of AzureFirewallSubnet in Hub VNet"
}

variable "firewall_tier" {
  type    = string
  default = "Standard" # или "Premium"
}

variable "log_analytics_workspace_id" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
