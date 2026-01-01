variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }

variable "frontend_subnet_id" {
  type        = string
  description = "Subnet для frontend IP внутреннего LB"
}

variable "frontend_private_ip" {
  type        = string
  default     = null
  description = "Если хочешь статический private IP для LB. Иначе оставь null (динамический)."
}

variable "lb_port" {
  type    = number
  default = 80
}

variable "backend_port" {
  type    = number
  default = 80
}

variable "tags" {
  type    = map(string)
  default = {}
}
