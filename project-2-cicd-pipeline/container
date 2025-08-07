
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

resource "azurerm_resource_group" "rg" {
  name     = "container-rg"
  location = "westeurope"
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "container-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "env" {
  name                = "container-env"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  app_logs {
    destination = "log-analytics"
    log_analytics_configuration {
      customer_id = azurerm_log_analytics_workspace.law.workspace_id
      shared_key  = azurerm_log_analytics_workspace.law.primary_shared_key
    }
  }
}

resource "azurerm_container_app" "app" {
  name                         = "chiedo-container-app"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  revision_mode                = "Single"

template {
    container {
      name   = "mycontainer"
      image  = "$(acrName).azurecr.io/$(imagename):$(imagetag)"
      cpu    = 0.5
      memory = "1.0Gi"
    }
    scale {
      min_replicas = 1
      max_replicas = 2
    }
}  ingress {
    external_enabled = true
    target_port      = 80
    transport        = "auto"
}

  tags = {
    environment = "dev"
  }
}
