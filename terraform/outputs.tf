output "deploy_id" {
  value = random_string.deploy_id.result
}

output "compute" {
  value = "ssh -i ~/.ssh/oracledb opc@${oci_core_instance.compute.public_ip}"
}

output "database_password" {
  value     = random_password.database_password.result
  sensitive = true
}

output "sqlplus_config_par_full_path" {
  value     = oci_objectstorage_preauthrequest.sqlplus_config_object_preauthenticated_request.full_path
  sensitive = true
}
