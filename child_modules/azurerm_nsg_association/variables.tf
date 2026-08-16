variable "nsg_associations" {
  description = "Map of Subnet NSG associations to create"
  type = map(object({
    subnet_id                 = string
    network_security_group_id = string
  }))
}
