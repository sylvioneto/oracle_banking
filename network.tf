

resource "oci_core_vcn" "fcubs" {

  #Required
  compartment_id = var.compartment_id
  display_name   = "fcubs"
  freeform_tags  = { "env" = "dev" }
  cidr_block     = "10.0.0.0/16"

}

resource "oci_core_subnet" "public" {
  #Required
  cidr_block                 = var.public_subnet_cidr_block
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.fcubs.id
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_subnet" "private" {
  #Required
  cidr_block                 = var.private_subnet_cidr_block
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.fcubs.id
  prohibit_public_ip_on_vnic = true
}

