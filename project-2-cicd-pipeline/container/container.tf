terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {}
skip_provider_registration = true
}

terraform {
  backend "azurerm" {
    resource_group_name  = "statefile-cont"
    storage_account_name = "statefilecont"
    container_name       = "statefile-container"
    key                  = "terraform.tfstate"
  }
}

data "azurerm_container_registry" "acr" {
  name                = "dockerchiedo"
  resource_group_name = "docker-acr-rg"  
}

resource "azurerm_resource_group" "rg" {
  name     = "container-rg"
  location = "East US"
}

resource "azurerm_container_app_environment" "env" {
  name                       = "container-env"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
}

resource "azurerm_user_assigned_identity" "container_identity" {
  location            = azurerm_resource_group.rg.location
  name                = "container-identity"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.container_identity.principal_id
}

resource "azurerm_container_app" "app" {
  name                         = "chiedo-container-app"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.container_identity.id]
  }
  template {
    container {
      name   = "mycontainer"
      image = "${data.azurerm_container_registry.acr.login_server}/dockerimage:latest"
      cpu    = 0.5
      memory = "1Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  tags = {
    environment = "dev"
  }
}
