terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 1.8.5"
}
