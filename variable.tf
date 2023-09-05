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