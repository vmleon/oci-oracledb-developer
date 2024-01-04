resource "oci_objectstorage_bucket" "artifacts_bucket" {
  compartment_id = var.compartment_ocid
  name           = "oraclebd_artifacts_${random_string.deploy_id.result}"
  namespace      = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
}

resource "oci_objectstorage_object" "sqlplus_config_object" {
  bucket    = oci_objectstorage_bucket.artifacts_bucket.name
  content   = filebase64("${path.module}/generated/sqlplus_config.tar.gz")
  namespace = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  object    = "sqlplus_config.tar.gz" # FIXME include versioning

}

resource "oci_objectstorage_preauthrequest" "sqlplus_config_object_preauthenticated_request" {
  access_type  = "ObjectRead"
  bucket       = oci_objectstorage_bucket.artifacts_bucket.name
  name         = "sqlplus_config_par_${random_string.deploy_id.result}"
  namespace    = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  time_expires = timeadd(timestamp(), "168h") # 168h = 7 days

  object_name = oci_objectstorage_object.sqlplus_config_object.object
}
