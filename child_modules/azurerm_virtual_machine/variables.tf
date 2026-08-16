variable "vms" {
  description = "Map of Virtual Machines to create"
  type = map(object({
    name                 = string
    location             = string
    resource_group_name  = string
    size                 = string
    admin_username       = string
    admin_password       = string
    subnet_id            = string
    public_ip_id         = optional(string)
    nic_name             = string
    os_disk_caching      = optional(string, "ReadWrite")
    storage_account_type = optional(string, "Standard_LRS")
    image_publisher      = optional(string, "Canonical")
    image_offer          = optional(string, "0001-com-ubuntu-server-jammy")
    image_sku            = optional(string, "22_04-lts")
    image_version        = optional(string, "latest")
    tags                 = optional(map(string))
  }))
}
