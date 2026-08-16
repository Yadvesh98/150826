rgs = {
  "rg-preprod-01" = {
    name     = "rg-preprod-eastus-01"
    location = "East US"
    tags = {
      Environment = "Pre-Prod"
      ManagedBy   = "Terraform"
    }
  }
}

vnets = {
  "vnet-preprod-01" = {
    name          = "vnet-preprod-eastus-01"
    location      = "East US"
    rg_key        = "rg-preprod-01"
    address_space = ["10.10.0.0/16"]
    tags = {
      Environment = "Pre-Prod"
    }
  }
}

subnets = {
  "subnet-web" = {
    name             = "snet-web-preprod-01"
    rg_key           = "rg-preprod-01"
    vnet_key         = "vnet-preprod-01"
    address_prefixes = ["10.10.1.0/24"]
  }
  "subnet-db" = {
    name             = "snet-db-preprod-01"
    rg_key           = "rg-preprod-01"
    vnet_key         = "vnet-preprod-01"
    address_prefixes = ["10.10.2.0/24"]
  }
}

pips = {
  "pip-web-01" = {
    name              = "pip-web-preprod-01"
    location          = "East US"
    rg_key            = "rg-preprod-01"
    allocation_method = "Static"
    sku               = "Standard"
    tags = {
      Environment = "Pre-Prod"
    }
  }
}

nsgs = {
  "nsg-web" = {
    name     = "nsg-web-preprod-01"
    location = "East US"
    rg_key   = "rg-preprod-01"
    security_rules = [
      {
        name                       = "AllowHTTP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowSSH"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    tags = {
      Environment = "Pre-Prod"
    }
  }
}

nsg_associations = {
  "assoc-web" = {
    subnet_key = "subnet-web"
    nsg_key    = "nsg-web"
  }
}

key_vaults = {
  "kv-preprod-01" = {
    name     = "kvpreprodeastus01" # Must be globally unique in Azure (3-24 characters)
    location = "East US"
    rg_key   = "rg-preprod-01"
    secrets = {
      "vm-admin-password" = "" # Empty string triggers auto-generation of strong random password
    }
    tags = {
      Environment = "Pre-Prod"
    }
  }
}

vms = {
  "vm-web-01" = {
    name                 = "vmwebpreprod01"
    location             = "East US"
    rg_key               = "rg-preprod-01"
    size                 = "Standard_B2s"
    admin_username       = "azureadmin"
    kv_key               = "kv-preprod-01"
    secret_key           = "vm-admin-password"
    subnet_key           = "subnet-web"
    pip_key              = "pip-web-01"
    nic_name             = "nic-vmweb-preprod-01"
    os_disk_caching      = "ReadWrite"
    storage_account_type = "Standard_LRS"
    image_publisher      = "Canonical"
    image_offer          = "0001-com-ubuntu-server-jammy"
    image_sku            = "22_04-lts"
    image_version        = "latest"
    tags = {
      Environment = "Pre-Prod"
      Role        = "Web"
    }
  }
}
