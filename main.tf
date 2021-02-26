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
  region              = var.region
}

provider "oraclepaas" {
  user            = lookup(var.oraclepaas, "user")
  password        = lookup(var.oraclepaas, "password")
  identity_domain = lookup(var.oraclepaas, "identity_domain")
}
