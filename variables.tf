variable "location" {

  description = "The location where resources will be created."
  type        = string
  default     = "swedencentral"
}
variable "environment" {
  description = "The environment for the deployment (e.g., dev, test, prod)."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "The name of the project."
  type        = string
  default     = "my_project"
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default = {
  }
}

variable "owner" {
  description = "The owner of the resources."
  type        = string
  default     = "Yaroslav"

}

variable "hub_vnet_address_space" {
  type        = list(string)
  description = "Address space for the hub virtual network"
}

variable "hub_subnets" {
  description = "Map of subnet name to address prefix for hub VNet"
  type        = map(string)
}

variable "onprem_gateway_public_ip" {
  type    = string
  default = "203.0.113.10" # placeholder (TEST-NET-3)
}

variable "onprem_address_prefixes" {
  type    = list(string)
  default = ["192.168.10.0/24"] # placeholder
}

variable "vpn_shared_key" {
  type      = string
  sensitive = true

}
