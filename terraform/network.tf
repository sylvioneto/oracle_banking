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
  route_table_id             = oci_core_route_table.public.id
  prohibit_public_ip_on_vnic = false
  security_list_ids = [
    oci_core_security_list.public.id,
  ]
}

resource "oci_core_subnet" "private" {
  display_name               = "${local.full_name}-private"
  cidr_block                 = var.private_subnet_cidr_block
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.network.id
  route_table_id             = oci_core_route_table.private.id
  prohibit_public_ip_on_vnic = true
  security_list_ids = [
    oci_core_security_list.private.id,
    oci_core_security_list.oke.id,
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
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${local.full_name}-service-gw"
  services {
    service_id = data.oci_core_services.core_services.services.1.id
  }
}

resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
}

resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${local.full_name}-public"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

resource "oci_core_route_table" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${local.full_name}-private"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }

  route_rules {
    destination       = data.oci_core_services.core_services.services.1.cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.service_gateway.id
  }
}
