resource "local_file" "cysista_proxy" {
  content = tls_private_key.cysista_proxy.private_key_pem
  filename = "cysista-proxy.pem"
  file_permission = "0600"
}
