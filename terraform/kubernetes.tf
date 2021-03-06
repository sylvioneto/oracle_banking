locals {
  all_sources         = data.oci_containerengine_node_pool_option.test_node_pool_option.sources
  oracle_linux_images = [for source in local.all_sources : source.image_id if length(regexall("Oracle-Linux-[0-9]*.[0-9]*-20[0-9]*", source.source_name)) > 0]
}

resource "oci_containerengine_cluster" "cluster" {
  #Required
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_version
  name               = local.full_name
  vcn_id             = oci_core_vcn.network.id

  options {
    service_lb_subnet_ids = [oci_core_subnet.public.id]

    add_ons {
      is_kubernetes_dashboard_enabled = "true"
    }

    admission_controller_options {
      #Optional
      is_pod_security_policy_enabled = false
    }

    kubernetes_network_config {
      #Optional
      # pods_cidr     = var.pod_cidr
      # services_cidr = var.services_cidr
    }
  }

  depends_on = [oci_core_vcn.network]
}

resource "oci_containerengine_node_pool" "small" {
  #Required
  cluster_id         = oci_containerengine_cluster.cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_version
  name               = "${local.full_name}-small"
  node_shape         = var.k8s_node_shape
  ssh_public_key     = file(var.ssh_public_key_path)

  #Optional
  initial_node_labels {
    key   = "env"
    value = var.environment
  }

  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domain.ad.name
      subnet_id           = oci_core_subnet.private.id

    }
    size = var.k8s_node_pool_size
  }

  node_source_details {
    #Required
    image_id    = local.oracle_linux_images.0
    source_type = "IMAGE"

    #Optional
    boot_volume_size_in_gbs = "60"
  }

  depends_on = [oci_containerengine_cluster.cluster]
}
