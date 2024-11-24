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
