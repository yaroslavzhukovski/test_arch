variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }

variable "sku_name" {
  type    = string
  default = "Standard_B2s"
}

variable "instances" {
  type    = number
  default = 2
}

variable "platform_fault_domain_count" {
  type    = number
  default = 1
}

variable "subnet_id" {
  type        = string
  description = "Subnet where VMSS NICs will be placed (backend subnet)"
}

variable "backend_pool_id" {
  type        = string
  description = "ILB backend pool id"
}

variable "admin_username" {
  type = string
  validation {
    condition     = length(var.admin_username) >= 8
    error_message = "admin_username must be at least 8 characters."
  }
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key"
}

variable "custom_data" {
  type        = string
  description = "cloud-init text"
}

variable "tags" {
  type    = map(string)
  default = {}
}
