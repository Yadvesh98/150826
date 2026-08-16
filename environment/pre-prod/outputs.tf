output "resource_groups" {
  description = "Created resource groups"
  value       = module.azurerm_resource_group.rg_out
}

output "virtual_networks" {
  description = "Created virtual networks"
  value       = module.azurerm_virtual_network.vnet_out
}

output "subnets" {
  description = "Created subnets"
  value       = module.azurerm_subnet.subnet_out
}

output "public_ips" {
  description = "Created public IP addresses"
  value       = module.azurerm_public_ip.pip_out
}

output "virtual_machines" {
  description = "Created virtual machines"
  value       = module.azurerm_virtual_machine.vm_out
}
