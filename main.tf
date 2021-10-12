provider "google" {
  project = var.gcp_project
  region = var.gcp_region
  zone = var.gcp_zone
}

resource "tls_private_key" "cysista_proxy" {
  algorithm = "RSA"
  ecdsa_curve = "4096"
}

resource "local_file" "remote_ssh_private_key" {
  content = tls_private_key.cysista_proxy.private_key_pem
  filename = "${abspath(path.root)}/.ssh/cysista-proxy.pem"
  file_permission = "0600"
}

resource "google_compute_address" "cysista_proxy" {
  name = "cysista-proxy"
}

resource "google_compute_instance" "cysista_proxy" {
  name = "cysista-proxy"
  machine_type = var.machine_type

  tags = ["http-server", "https-server", "frp-server"]

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.cysista_proxy.address
    }
  }

  metadata = {
    ssh-keys = "${var.remote_user}:${tls_private_key.cysista_proxy.public_key_openssh}"
  }
}

locals {
  remote_host = google_compute_address.cysista_proxy.address
  remote_key_file = local_file.remote_ssh_private_key.filename
}

resource "null_resource" "ansible" {
  triggers = {
    always_run = timestamp()
  }

  depends_on = [
    google_compute_instance.cysista_proxy
  ]

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = local.remote_host
      port = 22
      user = var.remote_user
      private_key = file(local.remote_key_file)
    }

    inline = ["echo 'connected!'"]
  }

  provisioner "local-exec" {
    command = <<EOF
      ansible-galaxy role install -r requirements.yml -f
      ansible-galaxy collection install -r requirements.yml -f
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${local.remote_host}, -u ${var.remote_user} --key-file ${local.remote_key_file} playbook.yml
    EOF
  }
}
