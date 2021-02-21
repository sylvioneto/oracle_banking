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

resource "oci_database_db_system" "db_vm" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_id
  database_edition    = var.db_edition

  db_home {
    database {
      admin_password             = var.db_admin_password
      db_name                    = "fcubsdb"
      character_set              = var.character_set
      ncharacter_set             = var.n_character_set
      db_workload                = var.db_workload

      db_backup_config {
        auto_backup_enabled = false
      }
    }

    db_version                 = var.db_version
    display_name               = "fcubsdb"
  }

  db_system_options {
    storage_management = "LVM"
  }

  disk_redundancy         = var.db_disk_redundancy
  shape                   = var.db_system_shape
  subnet_id               = oci_core_subnet.public.id
  ssh_public_keys         = [var.ssh_public_key]
  display_name            = "${var.environment}-db-vm"
  hostname                = "${var.environment}-db-vm"
  domain                  = var.domain
  data_storage_size_in_gb = var.data_storage_size_in_gb
  license_model           = var.license_model
  node_count              = lookup(data.oci_database_db_system_shapes.db_system_shapes.db_system_shapes[0], "minimum_node_count")
  nsg_ids                 = [oci_core_network_security_group.network_security_group.id]

  freeform_tags = {
    "env" = var.environment
  }

  depends_on = [ oci_core_subnet.public ]
}
