resource "google_sql_database_instance" "main" {
  name             = "tp-sql-instance"
  database_version = "MYSQL_8_0"
  region           = var.region
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.default.id
    }
  }
}

resource "google_sql_database" "database" {
  name     = "app_db"
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "users" {
  name     = "admin"
  instance = google_sql_database_instance.main.name
  password = "password123"
  host     = "%"
}
