output "public_ip" {
  description = "VMLUE01 public IP"
  value       = azurerm_public_ip.publicip_vmlue01.ip_address
}

output "private_key" {
  description = "VMLUE01 private key"
  value       = tls_private_key.ssh_vmlue01.private_key_openssh
  sensitive   = true
}

output "public_key" {
  description = "VMLUE01 public key"
  value       = tls_private_key.ssh_vmlue01.public_key_openssh
}