provider "azurerm" {
  features {}
  use_cli  = true # local
  use_oidc = true # GitHub Actions
}

provider "azuread" {}
provider "random" {}
provider "azapi" {}
