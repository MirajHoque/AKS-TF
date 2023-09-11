variable "aks_rg" {
  description = "(Required) Name of the resource group where to create the aks"
  type        = string
}

variable "location" {
  description = "(Required) Define the region where the resource groups will be created"
  type        = string
}

variable "name" {
  description = "(Required) The name of the Managed Kubernetes Cluster to create."
  type        = string
}

variable "aks_node_rg" {
  description = "(Optional) The name of the Resource Group where the the Kubernetes Nodes should exist."
  type        = string
  default     = null
}

variable "agent_pool_subnet_id" {
  description = "(Required) The ID of the Subnet where the Agents in the Pool should be provisioned."
  default = "10.0.1.0/24"
}

# variable "agent_pools" {
#   description = "(Optional) List of agent_pools profile for multiple node pools"
#   type = list(object({
#     name                = string
#     count               = number
#     vm_size             = string
#     os_type             = string
#     os_disk_size_gb     = number
#     type                = string
#     max_pods            = number
#     availability_zones  = list(number)
#     enable_auto_scaling = bool
#     min_count           = number
#     max_count           = number
#   }))
#   default = [{
#     name                = "default"
#     count               = 1
#     vm_size             = "Standard_D2s_v3"
#     os_type             = "Linux"
#     os_disk_size_gb     = 50
#     type                = "VirtualMachineScaleSets"
#     max_pods            = 30
#     availability_zones  = [1, 2, 3]
#     enable_auto_scaling = true
#     min_count           = 1
#     max_count           = 3
#   }]
# }

variable "linux_admin_username" {
  description = "(Optional) User name for authentication to the Kubernetes linux agent virtual machines in the cluster."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "(Optional) SSH key for authentication to the Kubernetes linux agent virtual machines in the cluster."
  default     = "~/.ssh/akskey.pub"
}

variable "kubernetes_version" {
  description = "(Optional) Version of Kubernetes specified when creating the AKS managed cluster"
  default     = ""
}

variable "tags" {
  description = "(Required) Map of tags for the deployment"
}

variable "network_profile" {
  description = "(Optional) Sets up network profile for Advanced Networking."
  default = {
    # Use azure-cni for advanced networking
    network_plugin = "azure"
    # Sets up network policy to be used with Azure CNI. Currently supported values are calico and azure."
    network_policy     = "azure"
    service_cidr       = "10.100.0.0/16"
    dns_service_ip     = "10.100.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    # Specifies the SKU of the Load Balancer used for this Kubernetes Cluster. Use standard for when enable agent_pools availability_zones.
    load_balancer_sku = "standard"
  }
}

variable "client_id" {
    type = string
}
variable "client_secret" {
    type = string
}
