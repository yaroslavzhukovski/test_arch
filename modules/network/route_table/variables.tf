variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }

variable "subnet_ids" {
  type        = map(string)
  description = "Subnets to associate with this route table"
}

variable "routes" {
  type = map(object({
    address_prefix = string
    next_hop_type  = string
    next_hop_ip    = optional(string)
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
