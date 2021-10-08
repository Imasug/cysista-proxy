terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.87.0"
    }
  }
}

provider "google" {
  credentials = file(var.gcp_credentials)
  project = var.gcp_project
  region = var.gcp_region
  zone = var.gcp_zone
}

resource "tls_private_key" "cysista_proxy" {
  algorithm = "RSA"
  ecdsa_curve = "4096"
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
    ssh-keys = "cysista:${tls_private_key.cysista_proxy.public_key_openssh}"
  }
}
