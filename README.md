# Oracle Banking
Use repository to create the infrastructure required to run Oracle Banking 14.4.

This IaC will create:
- VNC
- Public and Private subnets
- Firewall rules
- Database System with FCUBS database
- Kubernetes cluster

# Usage
1. Open the `private.auto.tfvars` file and set the values:
```
// authentication
tenancy_ocid     = "ocid1.tenancy.oc1..xxxxxxxxxxx"
user_ocid        = "ocid1.user.oc1..xxxxxxx"
fingerprint      = "0000000000000000"
private_key_path = "my_oci_key.pem"
compartment_id   = "ocid1.compartment.oc1..xxxxxxxxxxxxxxxxxx"

// cloud infrastructure
domain         = "xxxxxxxx"
ssh_public_key = "xxxxxxxx"
```

2. Run Terraform
```
$ terraform init
$ terraform plan -out fcubs.tfplan
$ terraform apply fcubs.tfplan
```

3. Go to https://cloud.oracle.com dashboard to see the resources.

