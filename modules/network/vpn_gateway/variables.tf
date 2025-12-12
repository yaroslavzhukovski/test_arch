variable "name" {
  type        = string
  description = "VPN Gateway name"
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "gateway_subnet_id" {
  type        = string
  description = "ID of GatewaySubnet in Hub VNet"
}

variable "sku" {
  type        = string
  description = "VPN Gateway SKU (e.g., VpnGw1AZ)"
  default     = "VpnGw1AZ"
}

variable "active_active" {
  type    = bool
  default = false
}

variable "enable_bgp" {
  type    = bool
  default = true
}

variable "bgp_asn" {
  type    = number
  default = 65515
}

variable "tags" {
  type    = map(string)
  default = {}
}
