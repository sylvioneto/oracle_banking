data "oci_database_db_system_shapes" "db_system_shapes" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_id

  filter {
    name   = "shape"
    values = [var.db_system_shape]
  }
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.compartment_id
  ad_number      = 1
}
