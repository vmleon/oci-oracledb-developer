locals {
  cloud_init_content = templatefile("${path.module}/userdata/bootstrap.tftpl", {
    sqlplus_config_par_full_path = oci_objectstorage_preauthrequest.sqlplus_config_object_preauthenticated_request.full_path
  })
}

variable "instance_shape" {
  default = "VM.Standard.E4.Flex"
}

data "oci_core_images" "ol8_images" {
  compartment_id           = var.compartment_ocid
  shape                    = var.instance_shape
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "compute" {
  availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[0], "name")
  compartment_id      = var.compartment_ocid
  display_name        = "compute_${random_string.deploy_id.result}"
  shape               = var.instance_shape

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(local.cloud_init_content)
  }

  shape_config {
    ocpus         = 1
    memory_in_gbs = 8
  }

  create_vnic_details {
    subnet_id                 = oci_core_subnet.publicsubnet.id
    display_name              = "compute"
    assign_public_ip          = true
    assign_private_dns_record = true
    hostname_label            = "compute"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ol8_images.images[0].id
  }

  timeouts {
    create = "60m"
  }

}
