# Oracle Banking Terraform
Use repository to create the infrastructure required to run Oracle Banking 14.4

# Usage
1. Authenticate to Oracle Cloud.
```
oci session refresh --profile terraform
```
2. Create a auto.tfvars file with your private values:
```
ssh_public_key="foo"
compartment_id="something"
domain="mydomain"
```
3. Run Terraform
```
$ terraform init
$ terraform plan -out myplan.tfplan
$ terraform apply myplan.tfplan
```
4. Go to https://cloud.oracle.com dashboard to see the resources.

