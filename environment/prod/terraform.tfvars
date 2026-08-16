rgs = {
  "rg-prod-01" = {
    name     = "rg-prod-eastus-01"
    location = "East US"
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
    }
  }
}

vnets = {
  "vnet-prod-01" = {
    name          = "vnet-prod-eastus-01"
    location      = "East US"
    rg_key        = "rg-prod-01"
    address_space = ["10.20.0.0/16"]
    tags = {
      Environment = "Production"
    }
  }
}

subnets = {
  "subnet-web" = {
    name             = "snet-web-prod-01"
    rg_key           = "rg-prod-01"
    vnet_key         = "vnet-prod-01"
    address_prefixes = ["10.20.1.0/24"]
  }
  "subnet-app" = {
    name             = "snet-app-prod-01"
    rg_key           = "rg-prod-01"
    vnet_key         = "vnet-prod-01"
    address_prefixes = ["10.20.2.0/24"]
  }
  "subnet-db" = {
    name             = "snet-db-prod-01"
    rg_key           = "rg-prod-01"
    vnet_key         = "vnet-prod-01"
    address_prefixes = ["10.20.3.0/24"]
  }
}

pips = {
  "pip-web-01" = {
    name              = "pip-web-prod-01"
    location          = "East US"
    rg_key            = "rg-prod-01"
    allocation_method = "Static"
    sku               = "Standard"
    tags = {
      Environment = "Production"
    }
  }
}

nsgs = {
  "nsg-web" = {
    name     = "nsg-web-prod-01"
    location = "East US"
    rg_key   = "rg-prod-01"
    security_rules = [
      {
        name                       = "AllowHTTPS"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowHTTP"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_address_prefix = "*"
      }
    ]
    tags = {
      Environment = "Production"
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
  "kv-prod-01" = {
    name     = "kvprodeastus01" # Must be globally unique in Azure (3-24 characters)
    location = "East US"
    rg_key   = "rg-prod-01"
    secrets = {
      "vm-admin-password" = "" # Empty string triggers auto-generation of strong random password
    }
    tags = {
      Environment = "Production"
    }
  }
}

vms = {
  "vm-web-01" = {
    name                 = "vmwebprod01"
    location             = "East US"
    rg_key               = "rg-prod-01"
    size                 = "Standard_D2s_v3"
    admin_username       = "azureadmin"
    kv_key               = "kv-prod-01"
    secret_key           = "vm-admin-password"
    subnet_key           = "subnet-web"
    pip_key              = "pip-web-01"
    nic_name             = "nic-vmweb-prod-01"
    os_disk_caching      = "ReadWrite"
    storage_account_type = "Premium_LRS"
    image_publisher      = "Canonical"
    image_offer          = "0001-com-ubuntu-server-jammy"
    image_sku            = "22_04-lts"
    image_version        = "latest"
    tags = {
      Environment = "Production"
      Role        = "Web"
    }
  }
}
