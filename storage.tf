resource "google_storage_bucket" "tp_bucket" {
  count    = var.create_storage ? 1 : 0
  name     = "bucket-terraform-tp-493411-dev"
  location = "europe-west1"
  force_destroy = true
  uniform_bucket_level_access = true
}
