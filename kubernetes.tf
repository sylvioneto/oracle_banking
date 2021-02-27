resource "oci_containerengine_cluster" "cluster" {
  #Required
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_version
  name               = local.full_name
  vcn_id             = oci_core_vcn.network.id

  options {
    service_lb_subnet_ids = [oci_core_subnet.public.id]

    add_ons {
    }

    admission_controller_options {
    }

    kubernetes_network_config {
      #Optional
      # pods_cidr     = "10.1.0.0/16"
      # services_cidr = "10.2.0.0/16"
    }
  }
}

resource "oci_containerengine_node_pool" "small" {
  #Required
  cluster_id         = oci_containerengine_cluster.cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_version
  name               = "${local.full_name}-small"
  node_shape         = "VM.Standard2.1"

  #Optional
  initial_node_labels {
    #Optional
    # key   = "cluster"
    # value = "value"
  }

  node_config_details {
    placement_configs {
      subnet_id = oci_core_subnet.private.id
    }
  }

  node_source_details {
    #Required
    image_id    = local.oracle_linux_images.0
    source_type = "IMAGE"

    #Optional
    boot_volume_size_in_gbs = "60"
  }

  quantity_per_subnet = var.k8s_node_per_subnet
  ssh_public_key      = var.ssh_public_key
}
