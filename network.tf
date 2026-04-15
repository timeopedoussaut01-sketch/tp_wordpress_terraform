# VPC
resource "google_compute_network" "default" {
  name                    = "tp-vpc"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "default" {
  name          = "tp-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.default.id
}

# IP Publique pour le Load Balancer
resource "google_compute_global_address" "default" {
  name = "lb-static-ip"
}

# Health Check (obligatoire pour le Backend)
resource "google_compute_health_check" "default" {
  name = "http-health-check"
  http_health_check {
    port = 80
  }
}

# Backend Service
resource "google_compute_backend_service" "default" {
  name                  = "backend-service"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_health_check.default.id]
  backend {
    group = google_compute_region_instance_group_manager.tp_igm.instance_group
  }
}

# URL Map
resource "google_compute_url_map" "default" {
  name            = "web-map"
  default_service = google_compute_backend_service.default.id
}

# HTTP Proxy
resource "google_compute_target_http_proxy" "default" {
  name    = "http-proxy"
  url_map = google_compute_url_map.default.id
}

# Forwarding Rule (Point d'entrée final)
resource "google_compute_global_forwarding_rule" "default" {
  name       = "http-content-rule"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
  ip_address = google_compute_global_address.default.address
}

# Firewall
resource "google_compute_firewall" "default" {
  name    = "allow-http"
  network = google_compute_network.default.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}
