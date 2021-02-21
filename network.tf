data "oci_core_services" "core_services" {}

resource "oci_core_vcn" "network" {
  compartment_id = var.compartment_id
  display_name   = var.environment
  cidr_block     = var.network_cidr_block
  freeform_tags  = { "env" = var.environment }
}

resource "oci_core_subnet" "public" {
  display_name               = "${var.environment}-public"
  cidr_block                 = var.public_subnet_cidr_block
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.network.id
  prohibit_public_ip_on_vnic = false
  security_list_ids          = [oci_core_security_list.public.id]

  depends_on = [ oci_core_vcn.network, oci_core_security_list.public ]
}

resource "oci_core_subnet" "private" {
  display_name               = "${var.environment}-private"
  cidr_block                 = var.private_subnet_cidr_block
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.network.id
  prohibit_public_ip_on_vnic = true

  depends_on = [ oci_core_vcn.network ]
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${var.environment}-internet-gateway"
}

resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = var.compartment_id
  services {
    service_id = data.oci_core_services.core_services.services.0.id
  }
  vcn_id = oci_core_vcn.network.id
}

resource "oci_core_network_security_group" "network_security_group" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${var.environment}-secutiry-group"
}


resource "oci_core_route_table" "route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${var.environment}-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

resource "oci_core_security_list" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${var.environment}-public-rules"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  // allow outbound udp traffic on a port range
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "17" // udp
    stateless   = true
  }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "1"
    stateless   = true
  }

  // allow inbound ssh traffic from a specific port
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
    stateless = true
  }

  // allow inbound from customer site
  ingress_security_rules {
    description = "allow-external-db-connection"
    source      = "0.0.0.0/0"
    stateless   = false
    protocol    = "6"
    tcp_options {
      min = 1521
      max = 1522
    }
  }
}

