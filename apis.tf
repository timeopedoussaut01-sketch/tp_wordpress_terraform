variable "gcp_service_list" {
  description = "Liste des APIs a activer"
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com"
  ]
}

resource "google_project_service" "gcp_services" {
  for_each = toset(var.gcp_service_list)
  project  = var.project_id
  service  = each.key
  disable_on_destroy = false
}
