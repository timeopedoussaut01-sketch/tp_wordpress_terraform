resource "google_storage_bucket" "tp_bucket" {
  name          = "bucket-${var.project_id}-dev"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}
