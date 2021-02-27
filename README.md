# Oracle Banking Terraform
Use the terraform module in this repository to create infrastructure resources required to run Oracle Banking.

This IaC will create:
- Network
- Public and Private subnets
- Security rules
- Database System with FCUBS database
- Kubernetes cluster

# Usage
```hcl
provider "oci" {
  region           = "ca-toronto-1"

  // from your Oracle Cloud account
  tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaa"
  user_ocid        = "ocid1.user.oc1..aaaaaaabbbbbbbbbbbbbb"
  fingerprint      = "99:99:99:32:f7:07:e1:a1:31:c1:29:12:b8:99:63:b6"

  // api key
  private_key_path = "C:\\github\\oracle_banking\\keys\\oracleidentitycloudservice_sylvio.pedroza-02-27-00-41.pem"
}

module "fcubs" {
  source = "git::https://github.com/sylvioneto/oracle_banking.git//terraform"

  compartment_id      = "ocid1.compartment.oc1..aaaaaaaacccccccccccccc"
  domain              = "sneto.ca"
  environment         = "sandbox"
  ssh_public_key_path = "C:\\Users\\sylvi\\Downloads\\github\\oracle_banking\\keys\\ssh-key-2021-02-20.key.pub"
}
```
