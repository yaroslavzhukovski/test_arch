variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "storage_account_name" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "private_endpoint_subnet_id" {
  type = string
}

variable "containers" {
  type    = map(any)
  default = {}
}

variable "queues" {
  type    = map(any)
  default = {}
}

variable "shares" {
  type    = map(any)
  default = {}
}

variable "tables" {
  type    = map(any)
  default = {}
}
