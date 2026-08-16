variable "vnets" {
  description = "Map of Virtual Networks to create"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
    tags                = optional(map(string))
  }))
}
