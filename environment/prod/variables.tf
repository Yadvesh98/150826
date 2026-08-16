variable "rgs" {
  description = "Map of Resource Groups to create"
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string))
  }))
  default = {}
}

variable "vnets" {
  description = "Map of Virtual Networks to create"
  type = map(object({
    name          = string
    location      = string
    rg_key        = string
    address_space = list(string)
    tags          = optional(map(string))
  }))
  default = {}
}

variable "subnets" {
  description = "Map of Subnets to create"
  type = map(object({
    name             = string
    rg_key           = string
    vnet_key         = string
    address_prefixes = list(string)
  }))
  default = {}
}

variable "pips" {
  description = "Map of Public IPs to create"
  type = map(object({
    name              = string
    location          = string
    rg_key            = string
    allocation_method = string
    sku               = optional(string)
    tags              = optional(map(string))
  }))
  default = {}
}

variable "nsgs" {
  description = "Map of Network Security Groups and security rules to create"
  type = map(object({
    name     = string
    location = string
    rg_key   = string
    security_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string, "*")
      destination_port_range     = optional(string, "*")
      source_address_prefix      = optional(string, "*")
      destination_address_prefix = optional(string, "*")
    })), [])
    tags = optional(map(string))
  }))
  default = {}
}

variable "nsg_associations" {
  description = "Map of NSG to Subnet associations to create"
  type = map(object({
    subnet_key = string
    nsg_key    = string
  }))
  default = {}
}

variable "key_vaults" {
  description = "Map of Key Vaults and secrets to create"
  type = map(object({
    name                       = string
    location                   = string
    rg_key                     = string
    sku_name                   = optional(string, "standard")
    purge_protection_enabled   = optional(bool, false)
    soft_delete_retention_days = optional(number, 7)
    secrets                    = optional(map(string), {})
    tags                       = optional(map(string))
  }))
  default = {}
}

variable "vms" {
  description = "Map of Virtual Machines to create"
  type = map(object({
    name                 = string
    location             = string
    rg_key               = string
    size                 = string
    admin_username       = string
    kv_key               = string
    secret_key           = string
    subnet_key           = string
    pip_key              = optional(string)
    nic_name             = string
    os_disk_caching      = optional(string, "ReadWrite")
    storage_account_type = optional(string, "StandardSSD_LRS")
    image_publisher      = optional(string, "Canonical")
    image_offer          = optional(string, "0001-com-ubuntu-server-jammy")
    image_sku            = optional(string, "22_04-lts")
    image_version        = optional(string, "latest")
    tags                 = optional(map(string))
  }))
  default = {}
}
