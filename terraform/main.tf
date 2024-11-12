# Proveedor de Azure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}


# Grupo de Recursos
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Plan de App Service
resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "astro-app-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Free"
    size = "F1"
  }
}

# App Service para Astro (Frontend)
resource "azurerm_app_service" "web_app" {
  name                = "astro-frontend"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    linux_fx_version = "NODE|20-lts"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}

resource "azurerm_app_service" "django_app" {
  name                = "django-backend"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    linux_fx_version = "PYTHON|3.12" 
  }

  app_settings = {
    "DJANGO_SETTINGS_MODULE"   = "mi_proyecto.settings"
    "DATABASE_URL"             = "Server=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name};Database=${azurerm_mssql_database.database.name};User Id=${var.sql_admin_username};Password=${var.sql_admin_password};"
    "WEBSITE_RUN_FROM_PACKAGE" = "1" 
  }
}


# Servidor SQL
resource "azurerm_mssql_server" "sql_server" {
  name                         = "astrosqlserver${random_string.sql_suffix.result}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password

  minimum_tls_version = "1.2"
}

resource "random_string" "sql_suffix" {
  length  = 6
  special = false
  upper   = false
}

# Base de Datos SQL
resource "azurerm_mssql_database" "database" {
  name                = "astrodb"
  server_id           = azurerm_mssql_server.sql_server.id
  sku_name            = "Basic"
}