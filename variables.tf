// environment
variable "compartment_id" {
  default     = "ocid1.tenancy.oc1..aaaaaaaainki5vvjnq5jbgpgnkpckhyc2mm5qe5muc4cazhsxf3iamsft3aa"
  description = "Compartment ID"
}

variable "public_subnet_cidr_block" {
  default = "10.0.0.0/24"
}

variable "private_subnet_cidr_block" {
  default = "10.0.1.0/24"
}