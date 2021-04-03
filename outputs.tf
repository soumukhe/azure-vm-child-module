
output "PublicIP" {
  value = azurerm_public_ip.smterraformpublicip.ip_address
}

output "tls_private_key" { 
  value = tls_private_key.example_ssh.private_key_pem 
}

resource "local_file" "private_key" {
  content = tls_private_key.example_ssh.private_key_pem
  filename = var.privKey #"sshPrivateKey.priv"
}

output "adminUser" {
  value = var.adminUser
}

output "PrivateKeyName" {
   value = var.privKey
}
