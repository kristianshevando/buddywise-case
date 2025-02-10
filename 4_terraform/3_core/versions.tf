terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.114.0"
    }
    random = {
      source = "hashicorp/random"
      version = "=3.6.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.53.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "=4.0.4"
    }
    local = {
      source  = "hashicorp/local"
      version = "= 2.5.0"
    }
    external = {
      source = "hashicorp/external"
      version = "=2.3.2"
    }
    null = {
      source = "hashicorp/null"
      version = "=3.2.1"
    }
  }
  required_version = ">= 1.8.5"
}