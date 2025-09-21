output "resource_group_name" {
  value       = module.runner_rg.resource_group_name
  description = "The name of the Azure Resource Group"
}

output "resource_group_id" {
  value       = module.runner_rg.resource_group_id
  description = "The ID of the Azure Resource Group"
}

output "vnet_id" {
    value       = module.runner-vnet.vnet_id
    description = "ID of the VNet."
}

output "vnet_name" {
    value       = module.runner-vnet.vnet_name
    description = "Name of the VNet."
}

output "subnet_id" {
    value       = module.runner-subnet.subnet_id
    description = "ID of the Subnet."
}

output "subnet_name" {
    value       = module.runner-subnet.subnet_name
    description = "Name of the Subnet."
}

output "public_ip_id" {
    value       = module.runner-pip.public_ip_id
    description = "The ID of the Public IP."
}

output "public_ip_address" {
    value       = module.runner-pip.public_ip_address
    description = "The IP address of the Public IP."
}

output "public_ip_fqdn" {
    value       = module.runner-pip.public_ip_fqdn
    description = "The FQDN of the Public IP."
}

output "public_ip_name" {
    value       = module.runner-pip.public_ip_name
    description = "The name of the Public IP."
}


output "nic_id" {
    value       = module.runner-nic.nic_id
    description = "The ID of the network interface."
}

output "nic_private_ip_address" {
    value       = module.runner-nic.nic_private_ip_address
    description = "The private IP address of the network interface."
}

output "nic_name" {
    value       = module.runner-nic.nic_name
    description = "The name of the network interface."
}

output "nic_ip_configuration" {
    value       = module.runner-nic.nic_ip_configuration
    description = "The IP configuration of the network interface."
}

output "security_group_id" {
    value       = module.runner-sg.security_group_id
    description = "The ID of the Network Security Group"
}

output "security_group_name" {
    value       = module.runner-sg.security_group_name
    description = "The name of the Network Security Group"
}


output "ssh_command" {
    value = "ssh ${var.admin_username}@${module.runner-pip.public_ip_address}"
}

