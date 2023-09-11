resource "azurerm_container_registry" "aks_acr" {
  name                = var.containerRegistry
  resource_group_name = var.rgName
  location            = var.location
  sku                 = var.skuAcr
  admin_enabled       = false 
}