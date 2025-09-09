output "flux_private_key" {
  value     = module.tls_private_key.private_key_pem
  sensitive = true
}