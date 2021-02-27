resource "oci_core_security_list" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${local.full_name}-private"

  egress_security_rules {
    description = "allow outbound tcp traffic on all ports"
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  egress_security_rules {
    destination = "10.0.0.0/8"
    protocol    = "all"
    stateless   = true
  }

  ingress_security_rules {
    source      = "10.0.0.0/8"
    protocol    = "all"
    stateless   = true
  }
}

resource "oci_core_security_list" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${local.full_name}-public"

  egress_security_rules {
    description = "allow outbound tcp traffic on all ports"
    destination = "0.0.0.0/0"
    protocol    = "6"
  }
  
  ingress_security_rules {
    description = "allow internal traffic"
    source      = "0.0.0.0/0"
    protocol    = "6"
  }
}

resource "oci_core_security_list" "oke" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${local.full_name}-oke"

  ingress_security_rules {
    protocol = "6" // tcp
    source   = "130.35.0.0/16"

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = "6" // tcp
    source   = "138.1.0.0/17"

    tcp_options {
      min = 22
      max = 22
    }
  }
  ingress_security_rules {
    protocol = "6" // tcp
    source   = "147.154.0.0/16"

    tcp_options {
      min = 22
      max = 22
    }
  }
  ingress_security_rules {
    protocol = "6" // tcp
    source   = "192.29.0.0/16"

    tcp_options {
      min = 22
      max = 22
    }
  }

}