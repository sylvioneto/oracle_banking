resource "oci_core_security_list" "default" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${local.full_name}-security-list"

  egress_security_rules {
    description = "allow outbound tcp traffic on all ports"
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

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
    description = "ICMP ingress"
    protocol    = 1
    source      = "0.0.0.0/0"
    stateless   = true

    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    description = "allow oracle db connections"
    protocol    = "6" // tcp
    source      = "0.0.0.0/0"
    stateless   = false

    tcp_options {
      // These values correspond to the destination port range.
      min = 1521
      max = 1522
    }
  }


}