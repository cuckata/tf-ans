resource "random_string" "random" {
  length  = 8
  upper   = true
  lower   = true
  numeric = true
  special = false
}