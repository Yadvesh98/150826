output "vm_out" {
  description = "Map of created Virtual Machines"
  value       = azurerm_linux_virtual_machine.vm
}

output "nic_out" {
  description = "Map of created Network Interfaces"
  value       = azurerm_network_interface.nic
}
