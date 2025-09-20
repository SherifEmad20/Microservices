terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.45.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "3.0.2"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}