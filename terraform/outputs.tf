output "frontend_app_name" {
  value = azurerm_linux_web_app.web_app.name
}

output "frontend_app_url" {
  value = "https://${azurerm_linux_web_app.web_app.default_hostname}"
}

output "backend_app_name" {
  value = azurerm_linux_web_app.django_app.name
}

output "backend_app_url" {
  value = "https://${azurerm_linux_web_app.django_app.default_hostname}"
}

output "database_url" {
  value = "Server=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name};Database=${azurerm_mssql_database.database.name};User Id=${var.sql_admin_username};Password=${var.sql_admin_password};"
  sensitive = true
}
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

# Outputs para el Frontend
output "frontend_identity_client_id" {
  value = azurerm_user_assigned_identity.frontend_identity.client_id
}

output "frontend_identity_tenant_id" {
  value = azurerm_user_assigned_identity.frontend_identity.tenant_id
}

output "frontend_identity_principal_id" {
  value = azurerm_user_assigned_identity.frontend_identity.principal_id
}

# Outputs para el Backend
output "backend_identity_client_id" {
  value = azurerm_user_assigned_identity.backend_identity.client_id
}

output "backend_identity_tenant_id" {
  value = azurerm_user_assigned_identity.backend_identity.tenant_id
}

output "backend_identity_principal_id" {
  value = azurerm_user_assigned_identity.backend_identity.principal_id
}

# Output para la suscripción
output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

# Data source para la configuración actual
data "azurerm_client_config" "current" {}
