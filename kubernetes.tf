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

resource "oci_containerengine_node_pool" "node_pool" {
  #Required
  cluster_id         = oci_containerengine_cluster.cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = data.oci_containerengine_node_pool_option.test_node_pool_option.kubernetes_versions[0]
  name               = "tfPool"
  node_shape         = "VM.Standard2.1"
  subnet_ids         = [oci_core_subnet.public.id]

  #Optional
  initial_node_labels {
    #Optional
    # key   = "cluster"
    # value = "value"
  }

  node_source_details {
    #Required
    image_id    = local.oracle_linux_images.0
    source_type = "IMAGE"

    #Optional
    boot_volume_size_in_gbs = "60"
  }

  quantity_per_subnet = 1
  ssh_public_key      = var.ssh_public_key
}
