resource "azurerm_network_interface" "nic" {
  for_each = var.vms

  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = each.value.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = each.value.public_ip_id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.vms

  name                            = each.value.name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = each.value.size
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic[each.key].id]
  tags                            = each.value.tags

  os_disk {
    caching              = coalesce(each.value.os_disk_caching, "ReadWrite")
    storage_account_type = coalesce(each.value.storage_account_type, "Standard_LRS")
  }

  source_image_reference {
    publisher = coalesce(each.value.image_publisher, "Canonical")
    offer     = coalesce(each.value.image_offer, "0001-com-ubuntu-server-jammy")
    sku       = coalesce(each.value.image_sku, "22_04-lts")
    version   = coalesce(each.value.image_version, "latest")
  }
}
