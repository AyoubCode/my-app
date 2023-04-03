output "private_key" {
  value     = tls_private_key.p_key.private_key_pem
  sensitive = true
}