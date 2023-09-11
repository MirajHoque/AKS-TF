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

#client configuration
data "azurerm_client_config" "current" {}

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

#call module
module "keyvault" {
  source                      = "./module/keyvault"
  keyvalutName                = var.keyvalutName
  location                    = var.location
  rgName                      = var.rgName
  service_principal_name      = var.servicePrincipalName
  service_principal_object_id = module.servicePrincipal.service_principal_object_id
  service_principal_tenant_id = module.servicePrincipal.service_principal_tenant_id
}

resource "azurerm_key_vault_access_policy" "app" {
  key_vault_id = module.keyvault.keyValutID
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  application_id = module.servicePrincipal.service_principal_application_id

  key_permissions = [
    "Get",
    "List",
    "Restore",
    "Recover",
    "Delete"
  ]

  secret_permissions = [
    "Get",
    "List",
    "Restore",
    "Recover",
    "Delete"
  ]
}

#storing client id to key vault
resource "azurerm_key_vault_secret" "client_id" {
  name = var.client_id
  value = module.servicePrincipal.client_secret
  key_vault_id =  module.keyvault.keyValutID
}

#storing client secret to the key vault
resource "azurerm_key_vault_secret" "client_secret" {
  name = var.client_secret
  value = module.servicePrincipal.client_secret
  key_vault_id =  module.keyvault.keyValutID
}

#creating ssh key
# resource "tls_private_key" "linux_key" {
#   algorithm = "RSA"
#   rsa_bits = 4096
# }

# We want to save the private key to our machine
# We can then use this key to connect to our Linux VM

# #sore private key as local file
# resource "local_file" "linuxkey" {
#   filename="linuxkey.pem"  
#   content= tls_private_key.linux_key.private_key_pem 
# }

##storing client secret to the key vault
resource "azurerm_key_vault_secret" "akspubkey" {
  name = var.akspubkey
  value = "~/.ssh/akskey.pub"
  key_vault_id =  module.keyvault.keyValutID
}

#call module
module "acr" {
  source               = "./module/acr"
  containerRegistry = var.containerRegistry
  rgName = var.rgName
  location = var.location
  skuAcr = var.skuAcr

  depends_on = [
    azurerm_resource_group.mtc_rg
  ]
}

#add role to service principal
resource "azurerm_role_assignment" "acr_role" {
  scope                = module.acr.acrID
  role_definition_name = "AcrPush"
  #service principal id
  principal_id = module.servicePrincipal.service_principal_object_id

  depends_on = [
    module.servicePrincipal,
    module.acr
  ]
}

#call module
module "aks" {
  source = "./module/aks"
  tags = {
    Environment = "Dev"
  }
  location = var.location
  aks_rg = var.aks_rg
  name = var.clusterName
  aks_node_rg = var.aks_node_rg
  client_id = module.servicePrincipal.client_id
  client_secret = module.servicePrincipal.client_secret

  depends_on = [
    module.servicePrincipal
  ]
  
}