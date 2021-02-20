terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "4.11.0"
    }
  }
}

provider "oci" {
  auth                = "SecurityToken"
  config_file_profile = "terraform"
}
