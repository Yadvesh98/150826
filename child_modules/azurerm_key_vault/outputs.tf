output "kv_out" {
  description = "Map of created Key Vaults"
  value       = azurerm_key_vault.kv
}

output "secret_out" {
  description = "Map of created Key Vault Secrets"
  value       = azurerm_key_vault_secret.secret
  sensitive   = true
}
