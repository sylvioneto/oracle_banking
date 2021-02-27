resource "oci_database_db_system" "db_vm" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_id
  database_edition    = var.db_edition

  db_home {
    database {
      admin_password = var.db_admin_password
      db_name        = "FCUBS"
      character_set  = var.character_set
      ncharacter_set = var.n_character_set
      db_workload    = var.db_workload

      db_backup_config {
        auto_backup_enabled = false
      }
    }

    db_version   = var.db_version
    display_name = "${local.full_name}-dbhome"
  }

  db_system_options {
    storage_management = "LVM"
  }

  disk_redundancy         = var.db_disk_redundancy
  shape                   = var.db_system_shape
  subnet_id               = oci_core_subnet.public.id
  ssh_public_keys         = [var.ssh_public_key]
  display_name            = local.full_name
  hostname                = local.full_name
  domain                  = var.domain
  data_storage_size_in_gb = var.data_storage_size_in_gb
  license_model           = var.license_model
  node_count              = var.db_node_count

  freeform_tags = {
    "env" = var.environment
  }

  depends_on = [oci_core_subnet.public]
}
