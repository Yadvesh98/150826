variable "rgs" {
  description = "Map of Resource Groups to create"
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string))
  }))
}
