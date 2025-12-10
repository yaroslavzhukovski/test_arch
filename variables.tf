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
