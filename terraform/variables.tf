locals {
  full_name = "fcubs-${var.environment}"
}

// environment
variable "compartment_id" {
  description = "Compartment ID"
}

variable "environment" {
  description = "Environment name"
  default     = "sandbox"
}

// network
variable "network_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  default = "10.0.0.0/24"
}

variable "private_subnet_cidr_block" {
  default = "10.0.1.0/24"
}

// db system
variable "db_system_shape" {
  default = "VM.Standard2.1"
}

variable "db_edition" {
  default = "ENTERPRISE_EDITION"
}

variable "db_admin_password" {
  default = "BAking_#123"
}

variable "db_version" {
  default = "19.0.0.0"
}

variable "db_disk_redundancy" {
  default = "NORMAL"
}

variable "sparse_diskgroup" {
  default = true
}

variable "hostname" {
  default = "fcubsdb"
}

variable "domain" {
  default = "domain.com"
}

variable "host_user_name" {
  default = "opc"
}

variable "n_character_set" {
  default = "AL16UTF16"
}

variable "character_set" {
  default = "AL32UTF8"
}

variable "db_workload" {
  default = "OLTP"
}

variable "data_storage_size_in_gb" {
  default = "256"
}

variable "license_model" {
  default = "LICENSE_INCLUDED"
}

variable "db_node_count" {
  default = "1"
}

variable "ssh_public_key_path" {
  description = "SSH key to access the vms"
}

// kubernetes 
variable "k8s_node_pool_size" {
  default = 2
}

variable "k8s_version" {
  default = "v1.18.10"
}

variable "k8s_node_shape" {
  default = "VM.Standard2.1"
}
