resource "oci_core_security_list" "internet" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${local.full_name}-internet"

  egress_security_rules {
    description = "allow outbound tcp traffic on all ports"
    destination = "0.0.0.0/0"
    protocol    = "6"
  }
}

resource "oci_core_security_list" "ingress_all" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${local.full_name}-ingress-all"

  ingress_security_rules {
    description = "allow inbound ssh traffic"
    protocol    = "6" // tcp
    source      = "0.0.0.0/0"
    stateless   = false

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    description = "allow inbound ICMP"
    protocol    = 1
    source      = "0.0.0.0/0"
    stateless   = true

    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    description = "allow inbound oracle db connections"
    protocol    = "6" // tcp
    source      = "0.0.0.0/0"
    stateless   = false

    tcp_options {
      min = 1521
      max = 1522
    }
  }
}