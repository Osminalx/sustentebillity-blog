variable "resource_group_name" {
  type = string
  default = "astro-blog-rg"
}

variable "location" {
  type = string
  default = "eastus"
}

variable "sql_admin_username" {
  type = string
  default = "sqladmin"
}

variable "sql_admin_password" {
  type = string
  default = "Redes1"
}

variable "django_secret_key" {
  type = string
}

variable "debug" {
  type = bool
  default = false
}
