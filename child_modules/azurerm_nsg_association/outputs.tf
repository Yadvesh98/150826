output "nsg_assoc_out" {
  description = "Map of created NSG Subnet Associations"
  value       = azurerm_subnet_network_security_group_association.nsg_assoc
}
