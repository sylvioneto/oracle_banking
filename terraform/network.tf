data "oci_core_services" "core_services" {}

// network and subnets
resource "oci_core_vcn" "network" {
  compartment_id = var.compartment_id
  display_name   = local.full_name
  cidr_block     = var.network_cidr_block
  freeform_tags  = { "env" = var.environment }
}

resource "oci_core_subnet" "public" {
  display_name               = "${local.full_name}-public"
  cidr_block                 = var.public_subnet_cidr_block
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.network.id
  route_table_id             = oci_core_route_table.route_table.id
  prohibit_public_ip_on_vnic = false
  security_list_ids = [
    oci_core_security_list.internet.id,
    oci_core_security_list.ingress_all.id,
  ]
}

resource "oci_core_subnet" "private" {
  display_name               = "${local.full_name}-private"
  cidr_block                 = var.private_subnet_cidr_block
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.network.id
  route_table_id             = oci_core_route_table.route_table.id
  prohibit_public_ip_on_vnic = true
  security_list_ids = [
    oci_core_security_list.internet.id,
  ]
}

// internet connection
resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${local.full_name}-internet-gateway"
}

resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = var.compartment_id
  services {
    service_id = data.oci_core_services.core_services.services.0.id
  }
  vcn_id = oci_core_vcn.network.id
}

resource "oci_core_route_table" "route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${local.full_name}-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}
