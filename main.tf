terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.71.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {

  }
}

#resource group
resource "azurerm_resource_group" "mtc_rg" {
  name     = var.rgName
  location = var.location
}

#call module
module "servicePrincipal" {
  source               = "./module/servicePrincipal"
  servicePrincipalName = var.servicePrincipalName

  depends_on = [
    azurerm_resource_group.mtc_rg
  ]
}

#add role to service principal
resource "azurerm_role_assignment" "spn_role" {
  scope                = "/subscriptions/d8026e85-c3a9-4a33-acb5-88d88c4daf6c"
  role_definition_name = "Contributor"
  #service principal id
  principal_id = module.servicePrincipal.service_principal_object_id

  depends_on = [
    module.servicePrincipal
  ]
}