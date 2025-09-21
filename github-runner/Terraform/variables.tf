# Subscription ID for the Azure resources
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "f2df3cc0-75b8-4b87-8230-ab589470a407"
}

variable "location" {
  description = "The Azure location where the Resource Group will be created"
  type        = string
  default     = "UK West"
}

variable "resource_group_name" {
  description = "The name of the Azure Resource Group"
  type        = string
  default     = "gh-runner-rg"
}

variable "environment" {
  description = "The environment tag for the resources"
  type        = string
  default     = "Development"
}

variable "project" {
  description = "The project tag for the resources"
  type        = string
  default     = "Github runner"
}

variable "runner_Vnet_name" {
  description = "The name of the Virtual Network"
  type        = string
  default     = "runner-vnet"
}

variable "address_space_list" {
  description = "The address space list for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "The name of the Subnet"
  type        = string
  default     = "runner-subnet"
}

variable "subnet_address_prefixes" {
  description = "The address prefixes for the Subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "public_ip_name" {
    description = "The name of the Public IP"
    type        = string
    default     = "runner-pip"
}

variable "nic_name" {
    description = "The name of the network interface."
    type        = string
    default     = "runner-nic"
}

variable "ip_configuration_name" {
    description = "The name of the IP configuration."
    type        = string
    default     = "internal"
}

variable "private_ip_address_allocation" {
    description = "The private IP address allocation method. Possible values are 'Static' or 'Dynamic'."
    type        = string
    default     = "Dynamic"
}

variable "runner_rg_name" {
    description = "The name of the Resource Group"
    type        = string
    default     = "gh-runner-rg"
}

variable "allowed_ssh_cidr" {
    description = "The CIDR block allowed to access SSH (port 22)"
    type        = string
    default     = "0.0.0.0/0"
}

variable "vm_name" {
  description = "The name of the Virtual Machine."
  type        = string
  default     = "gh-runner-vm"
}

variable "vm_size" {
  description = "The size of the Virtual Machine."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "The admin username for the Virtual Machine."
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "The admin password for the Virtual Machine."
  type        = string
  default     = "p@ssw0rd1234!"
}
