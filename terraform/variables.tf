variable "gcp_credentials" {
  default = "/mnt/c/tmp/cysista-328317-c0f8847ea88b.json"
}

variable "gcp_project" {
  default = "cysista-328317"
}

variable "gcp_region" {
  default = "us-west1"
}

variable "gcp_zone" {
  default = "us-west1-b"
}

variable "machine_type" {
  default = "e2-micro"
}

variable "image" {
  default = "debian-cloud/debian-9"
}

variable "remote_user" {
  default = "cysista"
}