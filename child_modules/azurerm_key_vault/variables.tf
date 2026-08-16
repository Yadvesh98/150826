variable "key_vaults" {
  description = "Map of Key Vaults and secrets to create"
  type = map(object({
    name                       = string
    location                   = string
    resource_group_name        = string
    sku_name                   = optional(string, "standard")
    purge_protection_enabled   = optional(bool, false)
    soft_delete_retention_days = optional(number, 7)
    secrets                    = optional(map(string), {}) # Map of secret_name => secret_value (if empty/auto, auto-generates password)
    tags                       = optional(map(string))
  }))
}
