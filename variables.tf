variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "env" {
  type = string
}

variable "create_storage" {
  type    = bool
  default = true
}
