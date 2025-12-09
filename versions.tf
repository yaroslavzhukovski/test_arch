terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.51"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.7.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }

    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.8"
    }
  }
}
