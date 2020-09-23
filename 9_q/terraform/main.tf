resource "google_compute_instance" "default" {
  name         = "isucon9-q"
  machine_type = "n1-standard-1"
  zone         = "asia-northeast1-b"
  tags         = ["isucon-server"]

  boot_disk {
    initialize_params {
      size  = 20
      type  = "pd-standard"
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  // Local SSD disk
  # scratch_disk {
  #   interface = "SCSI"
  # }

  network_interface {
    network = "default"
    access_config {
        nat_ip = google_compute_address.static_ip.address
    }
  }

  metadata = {
    # block project ssh-key
    # https://qiita.com/sonots/items/6982b7bd9366ca7b98fd
    block-project-ssh-keys = "true"

    # setup ssh as "isucon9-user"
    ssh-keys = "isucon9-user:${file("~/.ssh/id_isucon9.pub")}"
    metadata_startup_script = "${file("../scripts/gce_init.sh")}"
  }

  service_account {
    scopes = ["logging-write", "monitoring-write"]
  }
}

resource "google_compute_address" "static_ip" {
  name = "isucon9-q-address"
}

# https://techblog.gmo-ap.jp/2017/11/16/terraform%E3%81%A7gcp%E7%92%B0%E5%A2%83%E3%82%92%E6%A7%8B%E7%AF%89%E3%81%97%E3%81%A6%E3%81%BF%E3%82%8B/
resource "google_compute_firewall" "allow-http" {
  name    = "default-allow-http"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["isucon-server"]
}

resource "google_compute_firewall" "allow-https" {
  name    = "default-allow-https"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["isucon-server"]
}

resource "google_compute_firewall" "allow-services" {
  name    = "allow-isucon9-services"
  network = google_compute_network.default.name
  
  allow {
    protocol = "tcp"
    ports    = ["5555", "7000", "8000", "19999"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["isucon-server"]
}

resource "google_compute_network" "default" {
  name = "isucon9-network"
}

# output IP Address
output "ip" {
  value = google_compute_address.static_ip.address
}

