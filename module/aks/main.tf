resource "azurerm_virtual_network" "mt_vnet" {
  name                = "mt-vnet"
  location            = var.location
  resource_group_name = var.aks_rg
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  tags = {
    Env             = "Demo"
    DR              = "Essential"
    ApplicationName = "Microservices"
  }
}

#creating k8s cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  dns_prefix          = var.name
  resource_group_name = var.aks_rg
  location            = var.location

  node_resource_group = var.aks_node_rg

  linux_profile {
    admin_username = var.linux_admin_username

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  #retrieve the latest version of Kubernetes supported by Azure Kubernetes Service if version is not set
  kubernetes_version = var.kubernetes_version != "" ? var.kubernetes_version : data.azurerm_kubernetes_service_versions.current.latest_version

   default_node_pool {
    name       = "default"
    vm_size    = "Standard_B2s"
    zones   = [1, 2]
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type"    = "system"
      "environment"      = "prod"
      "nodepoolos"       = "linux"
     } 
   tags = {
      "nodepool-type"    = "system"
      "environment"      = "prod"
      "nodepoolos"       = "linux"
   } 
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

#   role_based_access_control {
#     enabled = true
#   }

  network_profile {
    network_plugin     = var.network_profile.network_plugin
    network_policy     = var.network_profile.network_policy
    service_cidr       = var.network_profile.service_cidr
    dns_service_ip     = var.network_profile.dns_service_ip
    # docker_bridge_cidr = var.network_profile.docker_bridge_cidr
    load_balancer_sku  = lookup(var.network_profile, "load_balancer_sku", "basic")
  }

   tags = {
    Env             = "Demo"
    DR              = "Essential"
    ApplicationName = "Microservices"
  }
}
