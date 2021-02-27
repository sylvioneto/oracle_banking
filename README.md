# Oracle Banking Terraform
Use repository to create the infrastructure required to run Oracle Banking 14.4.

This IaC will create:
- VPC ( called VCN in Oracle Cloud :) )
- Public and Private subnets
- Firewall rules
- Database System with FCUBS database
- Java Container Service (Weblogic)

# Usage
1. Authenticate to Oracle Clou with oci and create a profile called `terraform`
```
oci session authenticate 
```
Note: to refresh the token use `oci session refresh --profile terraform`

2. Create a `private.auto.tfvars` file with your private values:
```
compartment_id="something"
domain="mydomain"
ssh_public_key="foo"
```

3. Run Terraform
```
$ terraform init
$ terraform plan -out myplan.tfplan
$ terraform apply myplan.tfplan
```
4. Go to https://cloud.oracle.com dashboard to see the resources.

