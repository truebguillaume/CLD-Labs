# This file lists the providers used
# It also contains a ressources such as:
# - google_compute_instance
# - google_compute_firewall
#
# Each of those resources contains the configuration that is used for this resource

provider "google" {
  project     = var.gcp_project_id
  region      = "europe-west6-a"
  credentials = file("${var.gcp_service_account_key_file_path}")
}

resource "google_compute_instance" "default" {
  name         = var.gce_instance_name
  machine_type = "f1-micro"
  zone         = "europe-west6-a"

  metadata = {
    ssh-keys = "${var.gce_instance_user}:${file("${var.gce_ssh_pub_key_file_path}")}"
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}

resource "google_compute_firewall" "ssh" {
  name          = "allow-ssh"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]
  allow {
    ports    = ["22", "23"]
    protocol = "tcp"
  }
}

resource "google_compute_firewall" "http" {
  name          = "allow-http"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
}
