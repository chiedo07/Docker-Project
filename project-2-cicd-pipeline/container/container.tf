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
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "container-rg"
  location = "westeurope"
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = "container-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Container App Environment
resource "azurerm_container_app_environment" "env" {
  name                         = "container-env"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  log_analytics_workspace_id   = azurerm_log_analytics_workspace.law.id

  tags = {
    environment = "dev"
  }
}

# Container App
resource "azurerm_container_app" "app" {
  name                         = "chiedo-container-app"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  revision_mode                = "Single"

  template {
    container {
      name   = "mycontainer"
      image  = "dockerchiedo.azurecr.io/dockerimage:latest" # make sure this image exists in ACR
      cpu    = 0.5
      memory = "1.0Gi"
    }

    scale {
      min_replicas = 1
      max_replicas = 2
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
    transport        = "auto"
  }

  tags = {
    environment = "dev"
  }
}
