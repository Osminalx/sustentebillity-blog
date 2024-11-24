variable "resource_group_name" {
  type = string
  default = "astro-blog-rg"
}

variable "location" {
  type = string
  default = "westus"
}

variable "sql_admin_username" {
  type = string
  default = "sqladmin"
}

variable "sql_admin_password" {
  type = string
  default = "RedesF030201"
}

variable "django_secret_key" {
  type = string
  default = "HX8Zvl76PRxbSZ9VdyUuA7JUYBuFsAVaHr-emtZbyWWwUBdDqWoGDEKtOw3Pk5d1qYI"
}

variable "debug" {
  type = bool
  default = false
}
