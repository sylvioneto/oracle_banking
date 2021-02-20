data "oci_core_services" "core_services" {}

resource "oci_core_vcn" "network" {
  compartment_id = var.compartment_id
  display_name   = var.env_name
  freeform_tags  = { "env" = "dev" }
  cidr_block     = var.network_cidr_block
}

resource "oci_core_subnet" "public" {
  display_name               = "public-subnet"
  cidr_block                 = var.public_subnet_cidr_block
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.network.id
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_subnet" "private" {
  display_name               = "private-subnet"
  cidr_block                 = var.private_subnet_cidr_block
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.network.id
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_internet_gateway" "test_internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
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