# Proveedor de Azure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.90.0 "
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
resource "azurerm_service_plan" "app_service_plan" {
  name                = "astro-app-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name =  "F1"
}

# App Service para Astro (Frontend)
resource "azurerm_linux_web_app" "web_app" {
  name                = "astro-sustentability-frontend"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  site_config {
    application_stack {
      node_version = "20-lts"
    }
    always_on = false
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}

resource "azurerm_linux_web_app" "django_app" {
  name                = "django-sustentability-backend"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  site_config {
    application_stack {
      python_version = "3.12"
    }
    always_on = false
  }

  app_settings = {
    "DJANGO_SETTINGS_MODULE" = "mi_proyecto.settings"
    "DATABASE_URL"           = "Server=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name};Database=${azurerm_mssql_database.database.name};User Id=${var.sql_admin_username};Password=${var.sql_admin_password};"
    "SECRET_KEY"             = var.django_secret_key
    "DEBUG"                  = var.debug
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}

resource "azurerm_sql_firewall_rule" "allow_azure_services" {
  name                = "AllowAzureServices"
  server_name         = azurerm_mssql_server.sql_server.name
  resource_group_name = azurerm_resource_group.rg.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
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