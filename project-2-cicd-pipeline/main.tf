provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "acr_rg" {
  name     = "Docker-container-registry"
  location = "East UK"
}

resource "azurerm_container_registry" "acr" {
  name                     = "myuniqueacrname123" # must be globally unique
  resource_group_name      = azurerm_resource_group.acr_rg.name
  location                 = azurerm_resource_group.acr_rg.location
  sku                      = "Standard"          # Choices: Basic, Standard, Premium
  admin_enabled            = true                # Use false in production (use role-based access instead)
}
