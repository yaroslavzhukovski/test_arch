variable "resource_group_name" { type = string }

variable "hub_vnet_id" { type = string }
variable "hub_vnet_name" { type = string }

variable "spoke_vnet_id" { type = string }
variable "spoke_vnet_name" { type = string }

variable "hub_to_spoke_name" { type = string }
variable "spoke_to_hub_name" { type = string }

variable "allow_gateway_transit" {
  type    = bool
  default = true
}

variable "use_remote_gateways" {
  type    = bool
  default = true
}
