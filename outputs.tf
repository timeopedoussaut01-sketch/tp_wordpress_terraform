output "loadbalacing_ip" {
  value = google_compute_global_address.default.address
}
output "db_private_ip" {
  value = google_sql_database_instance.main.private_ip_address
}
