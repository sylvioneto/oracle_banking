resource "oraclepaas_java_service_instance" "jcs" {
  name               = "fcubs-app-server"
  description        = "Example Terraformed JCS with OCI DB"
  edition            = "EE"
  service_version    = "12cRelease213"
  metering_frequency = "HOURLY"

  ssh_public_key = var.ssh_public_key

  # OCI Settings
  region              = var.region
  availability_domain = data.oci_identity_availability_domain.ad.name
  subnet              = oci_core_subnet.public.id

  weblogic_server {
    shape = "VM.Standard2.1"

    connect_string = "//${oci_database_db_system.db_vm.hostname}-scan.${oci_core_subnet.public.subnet_domain_name}:1521/${oci_database_db_system.db_vm.db_home.0.database.0.pdb_name}.${oci_core_subnet.public.subnet_domain_name}"

    database {
      username = "sys"
      password = oci_database_db_system.db_vm.db_home.0.database.0.admin_password
    }

    admin {
      username = "weblogic"
      password = "Weblogic_1"
    }
  }

  backups {
    cloud_storage_container = "Storage-${var.domain}/java-service-instance-backup"
    auto_generate           = true
  }

  depends_on = [oci_database_db_system.db_vm]
}
