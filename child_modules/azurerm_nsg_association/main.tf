resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each = var.nsg_associations

  subnet_id                 = each.value.subnet_id
  network_security_group_id = each.value.network_security_group_id
}
