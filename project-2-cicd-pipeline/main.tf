
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}

}

resource "azurerm_resource_group" "acr_rg" {
  name     = "Docker-acr-rg"
  location = "East US"
}

resource "azurerm_container_registry" "acr" {
  name                = "Dockerchiedo"
  resource_group_name = azurerm_resource_group.acr_rg.name
  location            = azurerm_resource_group.acr_rg.location
  sku                 = "Basic"
  admin_enabled       = true
}
