resource "oci_core_virtual_network" "oracledbvcn" {
  compartment_id = var.compartment_ocid
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "Oracle DB VCN"
  dns_label      = "oracledb${random_string.deploy_id.result}"
}

resource "oci_core_internet_gateway" "oracledb_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "oracledbInternetGateway"
  vcn_id         = oci_core_virtual_network.oracledbvcn.id
}

resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_virtual_network.oracledbvcn.default_route_table_id
  display_name               = "DefaultRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.oracledb_internet_gateway.id
  }
}

resource "oci_core_subnet" "publicsubnet" {
  cidr_block        = "10.0.0.0/24"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.oracledbvcn.id
  display_name      = "Oracle DB Public Subnet ${random_string.deploy_id.result}"
  dns_label         = "public${random_string.deploy_id.result}"
  security_list_ids = [oci_core_virtual_network.oracledbvcn.default_security_list_id]
  route_table_id    = oci_core_virtual_network.oracledbvcn.default_route_table_id
  dhcp_options_id   = oci_core_virtual_network.oracledbvcn.default_dhcp_options_id
}
