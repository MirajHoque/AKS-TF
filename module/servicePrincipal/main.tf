data "azuread_client_config" "current" {} #reading data from client configuration (except subscription id)

#App registration
resource "azuread_application" "aks" {
  display_name = var.servicePrincipalName #user input
  owners       = [data.azuread_client_config.current.object_id] 
}

#attach service principal to App registration
resource "azuread_service_principal" "aks" {
  application_id               = azuread_application.aks.application_id
  app_role_assignment_required = true
  owners                       = [data.azuread_client_config.current.object_id]
}

#creating client secret
resource "azuread_service_principal_password" "secret" {
  display_name = "aksadosecret"
  service_principal_id = azuread_service_principal.aks.object_id 
}