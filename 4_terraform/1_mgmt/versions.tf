terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
      version = "=2.53.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.114.0"
    }
    random = {
      source = "hashicorp/random"
      version = "=3.6.1"
    }
    external = {
      source = "hashicorp/external"
      version = "=2.3.2"
    }
    null = {
      source = "hashicorp/null"
      version = "=3.2.1"
    }
    time = {
      source = "hashicorp/time"
      version = "=0.11.2"
    }
  }
  required_version = ">= 1.8.5"
}
