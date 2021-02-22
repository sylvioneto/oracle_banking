resource "oci_core_network_security_group" "public_db_sg" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.network.id
  display_name   = "${var.environment}-public-db-sg"
}

resource "oci_core_network_security_group_security_rule" "public_db_ingress" {
  network_security_group_id = oci_core_network_security_group.public_db_sg.id
  description               = "allow-external-to-db"
  direction                 = "INGRESS"
  protocol                  = 6 //TCP
  stateless                 = false

  source_type = "CIDR"
  source      = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      min = 1521
      max = 1522
    }
  }
}
