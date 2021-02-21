data "oci_core_services" "core_services" {}

resource "oci_core_vcn" "network" {
  compartment_id = var.compartment_id
  display_name   = var.environment
  freeform_tags  = { "env" = "dev" }
  cidr_block     = var.network_cidr_block
}

resource "oci_core_subnet" "public" {
  display_name               = "${var.environment}-public"
  cidr_block                 = var.public_subnet_cidr_block
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.network.id
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_subnet" "private" {
  display_name               = "${var.environment}-private"
  cidr_block                 = var.private_subnet_cidr_block
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.network.id
  prohibit_public_ip_on_vnic = true
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
  services {
    service_id = data.oci_core_services.core_services.services.1.id
  }
  vcn_id = oci_core_vcn.network.id
}

resource "oci_core_network_security_group" "network_security_group" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${var.environment}-default-secutiry-group"
}


resource "oci_core_route_table" "default" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${var.environment}-default-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

resource "oci_core_security_list" "default" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${var.environment}-default-secutiry-list"

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
    source   = "0.0.0.0/0"
    protocol = "6"
  }
}

