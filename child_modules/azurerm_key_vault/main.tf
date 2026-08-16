data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  for_each = var.key_vaults

  name                       = each.value.name
  location                   = each.value.location
  resource_group_name        = each.value.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = coalesce(each.value.sku_name, "standard")
  purge_protection_enabled   = coalesce(each.value.purge_protection_enabled, false)
  soft_delete_retention_days = coalesce(each.value.soft_delete_retention_days, 7)
  tags                       = each.value.tags

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover"
    ]
  }
}

# Flatten Key Vault + Secret pairs
locals {
  kv_secrets = flatten([
    for kv_key, kv_val in var.key_vaults : [
      for sec_key, sec_val in kv_val.secrets : {
        composite_key = "${kv_key}_${sec_key}"
        kv_key        = kv_key
        secret_name   = sec_key
        secret_value  = sec_val
      }
    ]
  ])
  kv_secrets_map = { for item in local.kv_secrets : item.composite_key => item }
}

resource "random_password" "auto_password" {
  for_each = local.kv_secrets_map

  length           = 16
  special          = true
  override_special = "!@#$%&*"
}

resource "azurerm_key_vault_secret" "secret" {
  for_each = local.kv_secrets_map

  name         = each.value.secret_name
  value        = each.value.secret_value != null && each.value.secret_value != "" ? each.value.secret_value : random_password.auto_password[each.key].result
  key_vault_id = azurerm_key_vault.kv[each.value.kv_key].id
}
