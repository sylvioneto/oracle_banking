resource "oci_containerengine_cluster" "cluster" {
  #Required
  compartment_id     = var.compartment_id
  kubernetes_version = data.oci_containerengine_cluster_option.cluster_option.kubernetes_versions[0]
  name               = local.full_name
  vcn_id             = oci_core_vcn.network.id

  #Optional
  options {
    service_lb_subnet_ids = [oci_core_subnet.public.id]

    #Optional
    add_ons {
      #Optional
      # is_kubernetes_dashboard_enabled = "true"
      # is_tiller_enabled               = "true"
    }

    admission_controller_options {
      #Optional
      # is_pod_security_policy_enabled = true
    }

    kubernetes_network_config {
      #Optional
      # pods_cidr     = "10.1.0.0/16"
      # services_cidr = "10.2.0.0/16"
    }
  }
}
