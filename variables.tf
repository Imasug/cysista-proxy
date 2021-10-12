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
  default = "/projects/centos-cloud/global/images/centos-stream-8-v20210916"
}

variable "remote_user" {
  default = "cysista"
}