variable "rgName" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  default     = "Canada Central"
  description = "where to put resources"
}

variable "servicePrincipalName" {
  type = string
}

variable "keyvalutName" {
  type = string
}

variable "client_id" {
  type = string
}
variable "client_secret" {
  type = string
}

variable "akspubkey" {
  
}
variable "containerRegistry" {
  type = string
  description = "Name of the container registry"
}
variable "skuAcr" {
  type = string
}
variable "aks_rg" {
  type = string
}
variable "clusterName" {
  type = string
}

variable "aks_node_rg" {
  type = string
}
