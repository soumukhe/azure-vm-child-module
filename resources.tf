
# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "smterraformgroup" {
    name     = var.resgrp
    location = var.region

    tags = {
        environment = var.resgrptag
    }
}

# Create virtual network
resource "azurerm_virtual_network" "smterraformnetwork" {
    name                = var.vnet
    address_space       = var.cidr
    location            = var.region
    resource_group_name = azurerm_resource_group.smterraformgroup.name

    tags = {
        environment = var.resgrptag
    }
}

# Create subnet
resource "azurerm_subnet" "smterraformsubnet" {
    name                 = var.subnetname
    resource_group_name  = azurerm_resource_group.smterraformgroup.name
    virtual_network_name = azurerm_virtual_network.smterraformnetwork.name
    address_prefixes       = var.subnet
}

# Create public IPs
resource "azurerm_public_ip" "smterraformpublicip" {
    name                         = var.publicip
    location                     = var.region
    resource_group_name          = azurerm_resource_group.smterraformgroup.name
    allocation_method            = "Static"  #"Dynamic"

    tags = {
        environment = var.resgrptag
    }
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "smterraformnsg" {
    name                = var.sgname
    location            = var.region
    resource_group_name = azurerm_resource_group.smterraformgroup.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = var.resgrptag
    }
}

# Create network interface
resource "azurerm_network_interface" "smterraformnic" {
    name                      = var.netIntName
    location                  = "eastus"
    resource_group_name       = azurerm_resource_group.smterraformgroup.name

    ip_configuration {
        name                          = var.ipName
        subnet_id                     = azurerm_subnet.smterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.smterraformpublicip.id
    }

    tags = {
        environment = var.resgrptag
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.smterraformnic.id
    network_security_group_id = azurerm_network_security_group.smterraformnsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.smterraformgroup.name
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "smstorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.smterraformgroup.name
    location                    = var.region
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = var.resgrptag
    }
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}


# Create virtual machine
resource "azurerm_linux_virtual_machine" "smterraformvm" {
    name                  = var.vmName
    location              = var.region
    resource_group_name   = azurerm_resource_group.smterraformgroup.name
    network_interface_ids = [azurerm_network_interface.smterraformnic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = var.osDiskName
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher =  var.imagePublisher #"Canonical"
        offer     = var.image #"UbuntuServer"
        sku       = var.imageSku # "18.04-LTS"
        version   = "latest"
    }

    computer_name  = var.vmName
    admin_username = var.adminUser #"azureuser"
    disable_password_authentication = true

    admin_ssh_key {
        username       = var.adminUser
        public_key     = tls_private_key.example_ssh.public_key_openssh
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.smstorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = var.resgrptag
    }
}


resource "null_resource" "chmodprivkey" {
  depends_on = [tls_private_key.example_ssh]
  triggers = {
    build_number = timestamp()
  }

  provisioner "local-exec" {
    command =   "chmod 400 ${var.privKey}"
  }
}


resource "null_resource" "update" {
  depends_on = [azurerm_linux_virtual_machine.smterraformvm,azurerm_public_ip.smterraformpublicip,azurerm_network_interface_security_group_association.example]

  provisioner "local-exec" {
    command = "sleep 120"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt upgrade -y"
    ]

    connection {
      type = "ssh"
      user = var.adminUser
      private_key = file(var.privKey)
      host = azurerm_public_ip.smterraformpublicip.ip_address
    }
  }
}


