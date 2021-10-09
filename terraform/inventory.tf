resource "local_file" "remote_ssh_private_key" {
  content = tls_private_key.cysista_proxy.private_key_pem
  filename = "${abspath(path.root)}/.ssh/cysista-proxy.pem"
  file_permission = "0600"
}

resource "local_file" "inventory" {
  content = templatefile("inventory.tpl", {
    ip = google_compute_address.cysista_proxy.address,
    user = var.remote_user
    key_file = local_file.remote_ssh_private_key.filename
  })
  filename = "inventory.yml"
}