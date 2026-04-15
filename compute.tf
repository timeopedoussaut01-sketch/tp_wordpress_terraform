# Template d'instance
resource "google_compute_instance_template" "tp_template" {
  name         = "web-server-template"
  machine_type = "e2-micro"

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = google_compute_network.default.id
    subnetwork = google_compute_subnetwork.default.id
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    echo "Hello de la part de Terraform sur GCP !" > /var/www/html/index.html
  EOT

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

# Manager du groupe d'instances (Le fameux tp_igm)
resource "google_compute_region_instance_group_manager" "tp_igm" {
  name               = "web-server-igm"
  region             = var.region
  base_instance_name = "web-app"

  version {
    instance_template = google_compute_instance_template.tp_template.id
  }

  target_size = 1
}

# Autoscaler
resource "google_compute_region_autoscaler" "tp_autoscaler" {
  name   = "web-region-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.tp_igm.id

  autoscaling_policy {
    max_replicas    = 2
    min_replicas    = 1
    cooldown_period = 60
    cpu_utilization {
      target = 0.5
    }
  }
}
