output "app_name" {
  value = azurerm_linux_web_app.example.name
}

output "app_url" {
  value = "https://${azurerm_linux_web_app.example.default_hostname}"
}

output "database_url" {
  value = "Server=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name};Database=${azurerm_mssql_database.database.name};User Id=${var.sql_admin_username};Password=${var.sql_admin_password};"
  sensitive = true
}