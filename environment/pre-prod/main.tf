module "azurerm_resource_group" {
  source = "../../child_modules/azurerm_resource_group"
  rgs    = var.rgs
}

module "azurerm_virtual_network" {
  source = "../../child_modules/azurerm_virtual_network"
  vnets = {
    for k, v in var.vnets : k => {
      name                = v.name
      location            = v.location
      resource_group_name = module.azurerm_resource_group.rg_out[v.rg_key].name
      address_space       = v.address_space
      tags                = v.tags
    }
  }
}

module "azurerm_subnet" {
  source = "../../child_modules/azurerm_subnet"
  subnets = {
    for k, v in var.subnets : k => {
      name                 = v.name
      resource_group_name  = module.azurerm_resource_group.rg_out[v.rg_key].name
      virtual_network_name = module.azurerm_virtual_network.vnet_out[v.vnet_key].name
      address_prefixes     = v.address_prefixes
    }
  }
}

module "azurerm_public_ip" {
  source = "../../child_modules/azurerm_public_ip"
  pips = {
    for k, v in var.pips : k => {
      name                = v.name
      location            = v.location
      resource_group_name = module.azurerm_resource_group.rg_out[v.rg_key].name
      allocation_method   = v.allocation_method
      sku                 = v.sku
      tags                = v.tags
    }
  }
}

module "azurerm_nsg" {
  source = "../../child_modules/azurerm_nsg"
  nsgs = {
    for k, v in var.nsgs : k => {
      name                = v.name
      location            = v.location
      resource_group_name = module.azurerm_resource_group.rg_out[v.rg_key].name
      security_rules      = v.security_rules
      tags                = v.tags
    }
  }
}

module "azurerm_nsg_association" {
  source = "../../child_modules/azurerm_nsg_association"
  nsg_associations = {
    for k, v in var.nsg_associations : k => {
      subnet_id                 = module.azurerm_subnet.subnet_out[v.subnet_key].id
      network_security_group_id = module.azurerm_nsg.nsg_out[v.nsg_key].id
    }
  }
}

module "azurerm_key_vault" {
  source = "../../child_modules/azurerm_key_vault"
  key_vaults = {
    for k, v in var.key_vaults : k => {
      name                       = v.name
      location                   = v.location
      resource_group_name        = module.azurerm_resource_group.rg_out[v.rg_key].name
      sku_name                   = v.sku_name
      purge_protection_enabled   = v.purge_protection_enabled
      soft_delete_retention_days = v.soft_delete_retention_days
      secrets                    = v.secrets
      tags                       = v.tags
    }
  }
}

module "azurerm_virtual_machine" {
  source = "../../child_modules/azurerm_virtual_machine"
  vms = {
    for k, v in var.vms : k => {
      name                 = v.name
      location             = v.location
      resource_group_name  = module.azurerm_resource_group.rg_out[v.rg_key].name
      size                 = v.size
      admin_username       = v.admin_username
      admin_password       = module.azurerm_key_vault.secret_out["${v.kv_key}_${v.secret_key}"].value
      subnet_id            = module.azurerm_subnet.subnet_out[v.subnet_key].id
      public_ip_id         = v.pip_key != null ? module.azurerm_public_ip.pip_out[v.pip_key].id : null
      nic_name             = v.nic_name
      os_disk_caching      = v.os_disk_caching
      storage_account_type = v.storage_account_type
      image_publisher      = v.image_publisher
      image_offer          = v.image_offer
      image_sku            = v.image_sku
      image_version        = v.image_version
      tags                 = v.tags
    }
  }
}
