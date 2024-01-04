resource "random_string" "deploy_id" {
  length  = 3
  special = false
}

resource "random_password" "database_password" {
  length           = 16
  special          = true
  min_numeric      = 3
  min_special      = 2
  min_lower        = 3
  min_upper        = 3
  override_special = "-_"
}
