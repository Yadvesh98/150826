variable "pips" {
  description = "Map of Public IPs to create"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    allocation_method   = string
    sku                 = optional(string)
    tags                = optional(map(string))
  }))
}
