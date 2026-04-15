resource "google_storage_bucket" "tp_bucket" {
  name          = "bucket-\-dev"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}
